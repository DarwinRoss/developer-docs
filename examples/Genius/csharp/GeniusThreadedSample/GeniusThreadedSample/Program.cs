using System;
using System.IO;
using System.Net;
using System.Threading.Tasks;
using System.Xml.Serialization;
using GeniusThreadedSample.TransportWeb;

namespace GeniusThreadedSample
{
    public class Program
    {
        private static void Main(string[] args)
        {
            // Declare credentials to be used with the Stage Transaction Request
            string credentialsName = "TEST MERCHANT";
            string credentialsSiteID = "XXXXXXXX";
            string credentialsKey = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX";
            string ipAddress = "192.168.0.123";

            // Build Transport request details
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

            // Stage Transaction
            TransportResponse transportResponse = transportServiceSoapClient.CreateTransaction(credentialsName, credentialsSiteID, credentialsKey, transportRequest);
            string transportKey = transportResponse.TransportKey;
            Console.WriteLine("TransportKey Received = {0}{1}", transportKey, Environment.NewLine);
            // Initiate transaction thread with received TransportKey
            Task<TransactionResult> transactionResult = GeniusSale($"http://{ipAddress}:8080/v2/pos?TransportKey={transportKey}&Format=XML");
            Console.WriteLine("Waiting 3 seconds before canceling transaction");
            System.Threading.Thread.Sleep(3000);
            Task<CancelResult> cancelResult = GeniusCancel($"http://{ipAddress}:8080/pos?Action=Cancel&Format=XML");
            cancelResult.Wait();
            Console.WriteLine("Cancel Result: {0}", cancelResult.Result.Status);
            transactionResult.Wait();
            Console.WriteLine("Transaction Result: {0}", transactionResult.Result.Status);

            // Close application
            Console.WriteLine("Press Any Key to Close");
            Console.ReadKey();
        }

        private static async Task<TransactionResult> GeniusSale(string geniusRequest)
        {
            WebRequest webRequest = WebRequest.Create(geniusRequest);
            using (WebResponse webResponse = await webRequest.GetResponseAsync())
            {
                using (Stream responseStream = webResponse.GetResponseStream())
                {
                    // Validate XML to Genius XSD class
                    StreamReader streamReader = new StreamReader(responseStream);
                    XmlSerializer xmlSerializer = new XmlSerializer(typeof(TransactionResult));
                    TransactionResult transactionResult = (TransactionResult)xmlSerializer.Deserialize(streamReader);
                    return transactionResult;
                }
            }
        }

        private static async Task<CancelResult> GeniusCancel(string geniusRequest)
        {
            WebRequest webRequest = WebRequest.Create(geniusRequest);
            using (WebResponse webResponse = await webRequest.GetResponseAsync())
            {
                using (Stream responseStream = webResponse.GetResponseStream())
                {
                    // Validate XML to Genius XSD class
                    StreamReader streamReader = new StreamReader(responseStream);
                    XmlSerializer xmlSerializer = new XmlSerializer(typeof(CancelResult));
                    CancelResult transactionResult = (CancelResult)xmlSerializer.Deserialize(streamReader);
                    return transactionResult;
                }
            }
        }
    }
}