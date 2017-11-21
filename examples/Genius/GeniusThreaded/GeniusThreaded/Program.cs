using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using GeniusThreaded.TransportWeb;
using System.Net;
using System.IO;
using System.Globalization;

namespace GeniusThreaded
{
    class Program
    {
        static string lineBreak = Environment.NewLine + "---------------------";
        static int requestId = 0;
        static void Main(string[] args)
        {
            GeniusMethods gMethods = new GeniusMethods();
            //Ask user to input MerchantWARE Credentials
            //Console.WriteLine("Enter MerchantWARE credentials - Name, SiteID, Key" + Environment.NewLine);
            //Console.WriteLine("Press Enter after each value" + Environment.NewLine);

            //Declare credentials entered as String, to be used with the Stage Transaction Request
            string credentialsName = "mltest";//Console.ReadLine();
            string credentialsSiteID = "11111111";// Console.ReadLine();
            string credentialsKey = "11111-11111-11111-11111-11111";//Console.ReadLine();
            //Console.WriteLine("" + Environment.NewLine);

            //Request for TransportKey
            Console.WriteLine("Staging Transaction" + Environment.NewLine);
            TransportServiceSoapClient TransportSoap = new TransportServiceSoapClient();
            TransportRequest TransportReq = new TransportRequest();
            TransportResponse TransportRes = new TransportResponse();

            //TransportRequest Object Parameters
            TransportReq.TransactionType = "sale";
            TransportReq.Amount = 1.01M;
            TransportReq.ClerkId = "1";
            TransportReq.OrderNumber = "1126";
            TransportReq.Dba = "Test DBA";
            TransportReq.SoftwareName = "Test Software";
            TransportReq.SoftwareVersion = "1.0";
            TransportReq.TransactionId = "102911";
            TransportReq.TerminalId = "01";
            TransportReq.PoNumber = "PO12345";
            TransportReq.ForceDuplicate = true;

            //Stage Transaction Request Parameters
            TransportRes = TransportSoap.CreateTransaction(credentialsName, credentialsSiteID, credentialsKey, TransportReq);

            //Receive TransportKey, Declare as String, display TransportKey on-screen
            string TPKey = TransportRes.TransportKey;
            Console.WriteLine("TransportKey Received = " + TPKey + Environment.NewLine);

            //Ask user to input IP Address of Genius
            Console.WriteLine("Enter Genius IP Address and press Enter" + Environment.NewLine);
            string ipAddress = Console.ReadLine();

            Console.WriteLine(lineBreak);

            //Initiate transaction
            GeniusThreader(ipAddress, TPKey, "TransportKey", "XML");
            Thread.Sleep(200);
            GeniusThreader(ipAddress, "", "Status", "XML");
            Thread.Sleep(200);
            GeniusThreader(ipAddress, "", "Status", "XML");

            //Default function to status
            string function = "status";

            //Start loop for additional functions
            while(true)
            {
                //Request function from user. Escape the loop on a blank input
                function = Console.ReadLine();
                if (function != "")
                    GeniusThreader(ipAddress, TPKey, function, "XML");
                else
                    break;
            }

            //Close application
            Console.WriteLine("Press Enter to Close");
            Console.ReadKey();
        }

        /// <summary>
        /// Function to build Genius communication thread.
        /// </summary>
        /// <param name="ipAddress"></param>
        /// <param name="TPKey"></param>
        /// <param name="function"></param>
        /// <param name="format"></param>
        static void GeniusThreader(string ipAddress, string TPKey, string function, string format)
        {
            List<string> GTObj = new List<string> { ipAddress, TPKey, function, format };
            new Thread(new ParameterizedThreadStart(GeniusSale)).Start(GTObj);
        }

        /// <summary>
        /// Communication function used by thread handler.
        /// GTObj contains strings from GeniusThreader
        /// </summary>
        /// <param name="GTObj"></param>
        static void GeniusSale(object GTObj)
        {
            //Explode Object from thread starter
            List<string> Objs = (List<string>)GTObj;
            string ipAddress = Objs[0];
            string TPKey = Objs[1];
            string function = Objs[2];
            string format = Objs[3];
            string geniusReq = "";

            ++requestId;
            int threadId = requestId;

            //Initiate function request to genius
            if (function == "TransportKey")
                geniusReq = String.Format("http://{0}:8080/v2/pos?TransportKey={1}&Format=XML", ipAddress, TPKey);
            else
                geniusReq = String.Format("http://{0}:8080/pos?Action={1}&Format=XML",ipAddress, function);
            
            //Get time for log
            Console.WriteLine("{0} Recevied {1} Request. Thread #{2}{3}", getTimestamp(), function, threadId, lineBreak);
            //Setting up Request and Response Objects
            HttpWebRequest WebReq = (HttpWebRequest)WebRequest.Create(geniusReq);
            HttpWebResponse WebResp = (HttpWebResponse)WebReq.GetResponse();

            //Parse out response data into XML format
            Stream objStream = WebReq.GetResponse().GetResponseStream();
            StreamReader objReader = new StreamReader(objStream);

            string sLine = "", responseXML = "";
            int i = 0;

            while (sLine != null)
            {
                i++;
                sLine = objReader.ReadLine();
                if (sLine != null)
                    responseXML += (sLine + Environment.NewLine);
            }

            //Display response data in XML format on-screen
            Console.WriteLine("{0} Received Response for Thread #{1}{3}{4}Response: {2}{3}", getTimestamp(), threadId, responseXML.TrimEnd(), lineBreak, Environment.NewLine);
        }

        static string getTimestamp()
        {
            return DateTime.UtcNow.ToString("yyyy-MM-dd HH:mm:ss.fff", CultureInfo.InvariantCulture);
        }
    }
}
