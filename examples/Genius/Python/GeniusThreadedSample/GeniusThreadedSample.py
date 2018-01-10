import urllib2
import xml.etree.ElementTree as ElementTree
import threading
import Queue
from zeep.client import Client

def genius_request(url, queue):
    # genius_response = urllib2.urlopen(url).read()
    try:
        genius_response = urllib2.urlopen(url)
        queue.put(genius_response.read())
    except urllib2.HTTPError, e:
        print "%s %s" % (e.code, e.args)
    except urllib2.URLError, e:
        print e.args


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

# Send Transport request and collect TransportKey and ValidationKey
transportResponse = transportSoap.CreateTransaction(credentialsName, credentialsSiteID, credentialsKey, transportRequest)
transportKey = transportResponse.TransportKey
validationKey = transportResponse.ValidationKey

print "TransportKey Received: %s" % transportKey
print "ValidationKey Received: %s\n" % validationKey

# Request Genius IP
ipAddress = raw_input("Genius IP: ")

# start request to Genius
geniusReq = "http://%s:8080/v2/pos?TransportKey=%s&Format=XML" % (ipAddress, transportKey)
geniusResponse = Queue.Queue()
geniusThread = threading.Thread(target=genius_request, args=(geniusReq, geniusResponse))
geniusThread.start()

# Start action watch loop
action = "Status"
actionQueue = Queue.Queue()
print "Entered additional Action loop. Enter commands such as `Status`, `Cancel`, `InitiateKeyedEntry`\n" \
      "Press Enter to break out of the loop."
while action != "":
    action = raw_input("Enter Action: ")
    if action != "":
        actionRequest = "http://%s:8080/v2/pos?Action=%s&Format=XML" % (ipAddress, action)
        thread = threading.Thread(target=genius_request, args=(actionRequest, actionQueue))
        thread.start()
        thread.join()
        print actionQueue.get()

# Join initial thread ready for the response
geniusThread.join()

# Print Response and Status of transaction
geniusResponseRaw = geniusResponse.get()
geniusXml = ElementTree.fromstring(geniusResponseRaw)
print "Transaction Response Data:\n%s" % geniusResponseRaw
print "Transaction Status: %s" % geniusXml.find("Status").text

# Check ValidationKey received against the one we received from Transport
transactionValidationKey = geniusXml.find("ValidationKey").text
if validationKey == transactionValidationKey:
    print "ValidationKey matched. Transaction information can be trusted."
else:
    print "ValidationKey did not match. Transaction information is untrusted."
