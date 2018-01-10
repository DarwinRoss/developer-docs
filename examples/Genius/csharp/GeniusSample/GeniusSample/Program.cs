using System;
using System.Threading;
using System.Threading.Tasks;
using GeniusSample.TransportWeb;
using System.Net;
using System.IO;
using System.Xml.Linq;
using System.Globalization;

namespace GeniusSample
{
    class Program
    {
        static string lineBreak = Environment.NewLine + "-------------------------";
        static void Main(string[] args)
        {
            //Ask user to input MerchantWARE Credentials
            Console.WriteLine("Enter MerchantWARE credentials - Name, SiteID, Key");
            Console.WriteLine("Press Enter after each value{0}", Environment.NewLine);

            //Declare credentials entered as String, to be used with the Stage Transaction Request
            string credentialsName = Console.ReadLine();
            string credentialsSiteID = Console.ReadLine();
            string credentialsKey = Console.ReadLine();
            Console.WriteLine();

            //Request for TransportKey
            Console.WriteLine("Staging Transaction{0}", Environment.NewLine);
            TransportServiceSoapClient transportSoap = new TransportServiceSoapClient();
            TransportRequest transportReq = new TransportRequest();
            TransportResponse transportRes = new TransportResponse();

            //TransportRequest Object Parameters
            transportReq.TransactionType = "sale";
            transportReq.Amount = 1.01M;
            transportReq.ClerkId = "1";
            transportReq.OrderNumber = "1126";
            transportReq.Dba = "Test DBA";
            transportReq.SoftwareName = "Test Software";
            transportReq.SoftwareVersion = "1.0";
            transportReq.TransactionId = "102911";
            transportReq.TerminalId = "01";
            transportReq.PoNumber = "PO12345";
            transportReq.ForceDuplicate = true;

            //Stage Transaction Request Parameters
            transportRes = transportSoap.CreateTransaction(credentialsName, credentialsSiteID, credentialsKey, transportReq);

            //Receive TransportKey, Declare as String, display TransportKey on-screen
            string tpKey = transportRes.TransportKey;
            Console.WriteLine("TransportKey Received = {0}{1}", tpKey, Environment.NewLine);

            //Ask user to input IP Address of Genius
            Console.WriteLine("Enter Genius IP Address and press Enter{0}", Environment.NewLine);
            string ipAddress = Console.ReadLine();
            Console.WriteLine("{0}Setup Complete. Starting Transaction{1}", Environment.NewLine, lineBreak);

            string geniusRequest = $"http://{ipAddress}:8080/v2/pos?TransportKey={tpKey}&Format=XML";
            //Initiate transaction thread with received TransportKey
            XElement transactionResult;
            WebRequest webReq = WebRequest.Create(geniusRequest);
            using (WebResponse webResp = webReq.GetResponse())
            {
                using (Stream responseStream = webResp.GetResponseStream())
                {
                    //Load and display response data in XML format on-screen
                    transactionResult = XElement.Load(responseStream);
                    Console.WriteLine("{0} Response: {2}{1}{3}", getTimestamp(), transactionResult, Environment.NewLine, lineBreak);
                }
            }
            //Write Transaction Result
            Console.WriteLine("{0} Transaction Result: {1}{2}{3}", getTimestamp(), transactionResult.Element("Status").Value, lineBreak, Environment.NewLine);

            //Close application
            Console.WriteLine("Press Any Key to Close");
            Console.ReadKey();
        }

        /// <summary>
        /// Return a clean timestamp for logging
        /// </summary>
        /// <returns></returns>
        static string getTimestamp()
        {
            return DateTime.UtcNow.ToString("yyyy-MM-dd HH:mm:ss.fff", CultureInfo.InvariantCulture);
        }
    }
}
