using System;
using GeniusSample.TransportWeb;
using System.Net;
using System.IO;
using System.Xml.Serialization;

namespace GeniusSample
{
    class Program
    {
        static void Main(string[] args)
        {
            //Declare credentials to be used with the Stage Transaction Request
            string credentialsName = "TEST MERCHANT";
            string credentialsSiteID = "XXXXXXXX";
            string credentialsKey = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX";
            string ipAddress = "192.168.0.123";

            //Request for TransportKey
            Console.WriteLine("Staging Transaction{0}", Environment.NewLine);
            TransportServiceSoapClient transportServiceSoapClient = new TransportServiceSoapClient();
            TransportRequest transportRequest = new TransportRequest
            {
                TransactionType = "sale",
                Amount = 1.01M,
                ClerkId = "1",
                OrderNumber = "1126",
                Dba = "Test DBA",
                SoftwareName = "Test Software",
                SoftwareVersion = "1.0",
                TransactionId = "102911",
                TerminalId = "01",
                PoNumber = "PO12345",
                ForceDuplicate = true,
            };
            TransportResponse transportResponse = new TransportResponse();

            //Stage Transaction
            transportResponse = transportServiceSoapClient.CreateTransaction(credentialsName, credentialsSiteID, credentialsKey, transportRequest);
            string transportKey = transportResponse.TransportKey;
            Console.WriteLine("TransportKey Received = {0}{1}", transportKey, Environment.NewLine);

            //Initiate transaction with TransportKey
            string transactionResultXml;
            WebRequest webReq = WebRequest.Create($"http://{ipAddress}:8080/v2/pos?TransportKey={transportKey}&Format=XML");
            using (WebResponse webResp = webReq.GetResponse())
            {
                using (Stream responseStream = webResp.GetResponseStream())
                {
                    //Load and display response data in XML format on-screen
                    StreamReader streamReader = new StreamReader(responseStream);
                    transactionResultXml = streamReader.ReadToEnd();
                    Console.WriteLine("{0}Response: {0}{1}", Environment.NewLine, transactionResultXml);
                }
            }

            //Validate XML to Genius XSD class
            XmlSerializer xmlSerializer = new XmlSerializer(typeof(TransactionResult));
            StringReader stringReader = new StringReader(transactionResultXml);
            TransactionResult transactionResult = (TransactionResult)xmlSerializer.Deserialize(stringReader);
            Console.WriteLine("{1}Transaction Result: {0}{1}", transactionResult.Status, Environment.NewLine);

            //Close application
            Console.WriteLine("Press Any Key to Close");
            Console.ReadKey();
        }
    }
}
