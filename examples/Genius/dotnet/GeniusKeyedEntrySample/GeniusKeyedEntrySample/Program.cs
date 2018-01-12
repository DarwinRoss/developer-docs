using System;
using System.Threading;
using System.Threading.Tasks;
using GeniusKeyedEntrySample.TransportWeb;
using System.Net;
using System.IO;
using System.Xml.Linq;
using System.Globalization;

namespace GeniusKeyedEntrySample
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

            //Initiate transaction thread with received TransportKey
            Task<XElement> transactionResult = GeniusInitiateSale(ipAddress, tpKey);

            //Attempt to start Keyed Entry
            GeniusKeyedEntry(ipAddress);

            //Wait for Transaction Results
            Console.WriteLine("{0} Waiting for Transaction Results{1}", getTimestamp(), lineBreak);
            transactionResult.Wait();

            //Write Transaction Result
            Console.WriteLine("{0} Transaction Result: {1}{2}{3}", getTimestamp(), transactionResult.Result.Element("Status").Value, lineBreak, Environment.NewLine);

            //Close application
            Console.WriteLine("Press Any Key to Close");
            Console.ReadKey();
        }

        /// <summary>
        /// Check terminal status and initiate Keyed Entry when ready
        /// </summary>
        /// <param name="ipAddress">Full URL string to send</param>
        static void GeniusKeyedEntry(string ipAddress)
        {
            string currentScreen = "99";
            bool geniusOnSaleScreen = false;
            string keyedEntryStatus;

            do
            {
                //Wait 1 Second then get the current screen
                Thread.Sleep(1000);
                Console.WriteLine("{0} Sending Status Request.{1}", getTimestamp(), lineBreak);
                currentScreen = GeniusRequest($"http://{ipAddress}:8080/v2/pos?Action=Status&Format=XML").Result.Element("CurrentScreen").Value;

                //Check the current screen and move on if we are on screen 02 or 03
                if (currentScreen == "02" || currentScreen == "03")
                {
                    Console.WriteLine("{0} Terminal is ready for KeyedEntry{1}", getTimestamp(), lineBreak);
                    geniusOnSaleScreen = true;
                }
                else
                {
                    Console.WriteLine("{0} Terminal is not Ready. CurrentScreen {1}. Waiting 1 second before trying again.{2}", getTimestamp(), currentScreen, lineBreak);
                }
            }
            while (!geniusOnSaleScreen);

            //Sent InitiateKeyedSale
            Console.WriteLine("{0} Sending InitiateKeyedEntry Request.{1}", getTimestamp(), lineBreak);
            keyedEntryStatus = GeniusRequest($"http://{ipAddress}:8080/v2/pos?Action=InitiateKeyedEntry&Format=XML").Result.Element("Status").Value;

            Console.WriteLine("{0} InitiateKeyedEntry Result: {1}{2}", getTimestamp(), keyedEntryStatus, lineBreak);
        }

        /// <summary>
        /// Function for Sending Genius Request and returning the XML Response
        /// </summary>
        /// <param name="url">Full URL string to send</param>
        /// <returns></returns>
        static async Task<XElement> GeniusRequest(string url)
        {
            XElement XmlDoc;
            WebRequest webReq = WebRequest.Create(url);
            using (WebResponse webResp = await webReq.GetResponseAsync())
            {
                using (Stream responseStream = webResp.GetResponseStream())
                {
                    //Load and display response data in XML format on-screen
                    XmlDoc = XElement.Load(responseStream);
                    Console.WriteLine("{0} Response: {2}{1}{3}", getTimestamp(), XmlDoc, Environment.NewLine, lineBreak);
                }
            }
            return XmlDoc;
        }

        /// <summary>
        /// Initiate a Sale to Genius and return Results
        /// </summary>
        /// <param name="ipAddress">IP Address of Genius</param>
        /// <param name="tpKey">TransportKey aquired from TransportWeb</param>
        static async Task<XElement> GeniusInitiateSale(string ipAddress, string tpKey)
        {
            //Create a Task Thread for us to capture the request later
            Console.WriteLine("{0} Sending TransportKey {1}{2}", getTimestamp(), tpKey, lineBreak);
            XElement transactionResponse = await GeniusRequest($"http://{ipAddress}:8080/v2/pos?TransportKey={tpKey}&Format=XML");
            return transactionResponse;
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
