using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CayanCheckoutSample.MerchantWARE45;

namespace CayanCheckoutSample
{
    using System.Text.RegularExpressions;

    public partial class Default : System.Web.UI.Page
    {

        private string Amount = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            Amount = this.Request.QueryString["Amount"] ?? String.Empty;

            decimal dec;

            if (Decimal.TryParse(Amount, out dec))
            {
                string encodeAmount = HttpUtility.HtmlEncode(Amount);
                this.ShoppingCartAmount.Text = "$" + encodeAmount;
            }
            else
            {
                Response.Redirect("Error.aspx", true);
            }
        }

        protected void SubmitButton_Click(object sender, EventArgs e)
        {

            var token = this.TokenHolder.Text;

            var tokenRegex = new Regex(@"^[a-zA-Z0-9_]{1,40}$");

            if (tokenRegex.IsMatch(token))
            {
                using (var service = new CreditSoapClient())
                {

                    MerchantCredentials credentials = new MerchantCredentials
                    {
                        //Replace *YOUR MERCHANTNAME HERE* with test credentials provided
                        MerchantName = "YOUR MERCHANTNAME HERE",
                        //Replace *YOUR SITEID HERE* with test credentials provided
                        MerchantSiteId = "YOUR SITEID HERE",
                        //Replace *YOUR MERCHANTKEY HERE* with test credentials provided
                        MerchantKey = "YOUR MERCHANTKEY HERE"
                    };

                    PaymentData paymentData = new PaymentData
                    {
                        VaultToken = token,
                        // Email address is optional, but required for Kount FraudScoring
                        CustomerEmailAddress = EmailAddress.Text,
                        Source = "Vault"

                    };

                    SaleRequest saleRequest = new SaleRequest
                    {
                        Amount = this.Amount,
                        RegisterNumber = "123",
                        MerchantTransactionId = "1234",
                        CardAcceptorTerminalId = "01"
                    };

                    var response = service.Sale(credentials, paymentData, saleRequest);

                    this.CheckoutPlaceHolder.Visible = false;
                    var error = response.ErrorMessage;

                    if (error != "")
                    {
                        this.ResponseMessage.Visible = false;
                        this.ReferenceNumber.Visible = false;
                        this.KountScore.Visible = false;
                        this.KountRecommendation.Visible = false;

                        this.ErrorMessage.Text = "<b>Error Message: </b>" + error;
                    }
                    else
                    {
                        this.ErrorMessage.Visible = false;
                        this.ResponseMessage.Text = "<b>Status: </b>" + response.ApprovalStatus;
                        this.ReferenceNumber.Text = "<b>Reference #: </b>" + response.Token;

                        if (response.FraudScoring != null)
                        {
                            this.KountScore.Text = "<b>Kount Score: </b>" + response.FraudScoring.Score;
                            this.KountRecommendation.Text = "<b>Kount Recommendation: </b>" + response.FraudScoring.Recommendation;
                        }
                        else
                        {
                            this.KountScore.Visible = false;
                            this.KountRecommendation.Visible = false;
                        }
                    }
                    this.TokenHolder.Text = string.Empty;
                    this.ResultsPlaceHolder.Visible = true;
                }
            }
            else
            {
                Response.Redirect("Error.aspx", true);
            }

        }
    }

}