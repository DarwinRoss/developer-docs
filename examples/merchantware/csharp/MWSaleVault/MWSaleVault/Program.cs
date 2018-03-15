using System;
using MWSaleVault.MWCredit;

namespace MWSaleVault
{
    class Program
    {
        static void Main(string[] args)
        {
            //Create Soap Client
            CreditSoapClient soapClient = new CreditSoapClient("CreditSoap");
            //Create MerchantCredentails object
            MerchantCredentials merchantCredentials = new MerchantCredentials
            {
                MerchantName = "TEST MERCHANT",
                MerchantSiteId = "XXXXXXXX",
                MerchantKey = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"
            };
            //Create PaymentData object
            PaymentData paymentData = new PaymentData
            {
                Source = "Vault",
                VaultToken = "OTT_LT1KSFBNOZB381037S",
            };
            //Create SaleRequest Object
            SaleRequest saleRequest = new SaleRequest
            {
                Amount = "1.01",
                TaxAmount = "0.10",
                InvoiceNumber = "1234",
                CardAcceptorTerminalId = "01",
                CustomerCode = "1234",
                PurchaseOrderNumber = "1234",
                EnablePartialAuthorization = "true"

            };
            //Run Sale
            TransactionResponse45 saleResponse = soapClient.Sale(merchantCredentials, paymentData, saleRequest);
            //Print Results
            Console.WriteLine("Sale Response: {0}{3} Token: {1}{3} Amount: ${2}{3}", saleResponse.ApprovalStatus, saleResponse.Token, saleResponse.Amount, Environment.NewLine);
            Console.WriteLine("Press Any Key to Close");
            Console.ReadKey();
        }
    }
}
