import Queue
import threading
import time
import urllib2
import xml.etree.ElementTree as ElementTree
from zeep.client import Client


def genius_request(url, queue=None):
    """
    Request handler for Genius communication
    :param url: Full URL String to send to the Genius Terminal.
    :param queue: optional queue variable for threaded response.
    :return: returns raw response if no thread queue provided.
    """
    genius_response = urllib2.urlopen(url).read()
    if queue is not None:
        queue.put(genius_response)
    else:
        return genius_response


def genius_keyed_entry(ip_address):
    """
    Keyed Entry loop
    Sends a Status request to the terminal until it reaches screen 02 or 03. Then Initiates the Keyed Entry mode.
    :param ip_address: IP Address of the device
    """
    genius_on_sale_screen = False

    while genius_on_sale_screen is False:
        time.sleep(1)
        print "\nSending Status Request"
        status_response = genius_request("http://%s:8080/v2/pos?Action=Status&Format=XML" % ip_address)
        current_screen = ElementTree.fromstring(status_response).find("CurrentScreen").text

        if current_screen == "02" or current_screen == "03":
            print "Terminal is ready for KeyedEntry"
            genius_on_sale_screen = True
        else:
            print "Terminal is not Ready. Current Screen: %s. Waiting 1 second before trying again." % current_screen

    keyed_entry_status = genius_request("http://%s:8080/v2/pos?Action=InitiateKeyedEntry&Format=XML" % ip_address)
    print "InitiateKeyedEntry Result: %s\n" % ElementTree.fromstring(keyed_entry_status).find("Status").text


# Generate WSDL and SOAP Objects
client = Client('https://transport.merchantware.net/v4/transportService.asmx?WSDL')
transportSoap = client.service
transportRequestType = client.get_type("ns0:TransportRequest")

# Populate Transport Request values
transportRequest = transportRequestType(
    TransactionType="sale",
    Amount=1.01,
    ClerkId="1",
    OrderNumber="1126",
    Dba="Test DBA",
    SoftwareName="Test Software",
    SoftwareVersion="1.0",
    TransactionId="102911",
    ForceDuplicate=True,
    PoNumber="PO12345",
    TaxAmount=0.00,
    EntryMode="Undefined"
)

# Request Credentials
print "Enter Merchant Credentials (Merchant Name, Merchant SiteID, Merchant Key)"
credentialsName = raw_input("Merchant Name: ")
credentialsSiteID = raw_input("Merchant SiteID: ")
credentialsKey = raw_input("Merchant Key: ")

# Send Transport request and collect TransportKey
transportResponse = transportSoap.CreateTransaction(credentialsName, credentialsSiteID, credentialsKey, transportRequest)
transportKey = transportResponse.TransportKey
print "TransportKey Received: %s\n" % transportKey

# Request Genius IP
ipAddress = raw_input("Enter Genius IP: ")

# start threaded request to Genius
print "\nSending TransportKey %s to Terminal %s" % (transportKey, ipAddress)
geniusReq = "http://%s:8080/v2/pos?TransportKey=%s&Format=XML" % (ipAddress, transportKey)
geniusResponse = Queue.Queue()
geniusThread = threading.Thread(target=genius_request, args=(geniusReq, geniusResponse))
geniusThread.start()

# Start Keyed Entry check
genius_keyed_entry(ipAddress)

# Join initial thread ready for the response
print "Waiting for transaction to Complete...\n"
geniusThread.join()

# Print Status of transaction details
geniusResponseRaw = geniusResponse.get()
geniusXml = ElementTree.fromstring(geniusResponseRaw)
print "Terminal Response:\n\n%s\n" % geniusResponseRaw
print "Transaction Result: %s" % geniusXml.find("Status").text

raw_input("Press Enter to close")
