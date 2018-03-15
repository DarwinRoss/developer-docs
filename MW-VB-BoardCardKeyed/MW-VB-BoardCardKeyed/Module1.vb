Imports MW_VB_BoardCardKeyed.MWCredit

Module Module1

    Sub Main()
        'Create Soap Client
        Dim soapClient As New CreditSoapClient

        'Create Credentails Object
        Dim merchantCredentials As New MerchantCredentials With {
        .MerchantName = "Test Merchant",
        .MerchantSiteId = "XXXXXXXX",
        .MerchantKey = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"
        }

        'Create PaymentData Object
        Dim paymentData As New MWCredit.PaymentData With {
        .Source = "KEYED",
        .CardNumber = "4012000033330026",
        .ExpirationDate = "1220",
        .CardHolder = "John Doe",
        .AvsStreetAddress = "1 Federal St",
        .AvsZipCode = "02110",
        .CardVerificationValue = "123"
        }

        'Create Request Object
        Dim boardingRequest As New BoardingRequest

        'Process Request
        Dim transactionResponse45 As MWCredit.VaultBoardingResponse45
        transactionResponse45 = soapClient.BoardCard(merchantCredentials, paymentData, boardingRequest)

        'Display Results
        Console.WriteLine(" Vault Token: {0} Error Code: {1} Error Message: {2} RFMIQ: {3}", transactionResponse45.VaultToken + vbNewLine, transactionResponse45.ErrorCode + vbNewLine, transactionResponse45.ErrorMessage + vbNewLine, transactionResponse45.Rfmiq + vbNewLine)
        Console.WriteLine("Press Any Key to Close")
        Console.ReadKey()
    End Sub

End Module