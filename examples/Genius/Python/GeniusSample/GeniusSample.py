import urllib2
import xml.etree.ElementTree as ElementTree
from zeep.client import Client

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
ipAddress = raw_input("Genius IP: ")

# Send request to Genius and print response
print "\nSending TransportKey %s to Terminal %s" % (transportKey, ipAddress)
geniusRequest = "http://%s:8080/v2/pos?TransportKey=%s&Format=XML" % (ipAddress, transportKey)
geniusResponse = urllib2.urlopen(geniusRequest).read()

# Print Status of transaction details
geniusXml = ElementTree.fromstring(geniusResponse)
print "Terminal Response:\n\n%s\n" % geniusResponse
print "Transaction Result: %s" % geniusXml.find("Status").text

raw_input("Press Enter to close")
