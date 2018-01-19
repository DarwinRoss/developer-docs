<?php
    $amount = 1.65;
    $referenceNumber = 0;
    $responseMessage = "Declined";

    function isPost($server){
        return (strtoupper($server['REQUEST_METHOD']) == 'POST');
    }

    function requestSale($token, $amount){
        global $referenceNumber, $responseMessage;
        $client = new SoapClient('https://ps1.merchantware.net/Merchantware/ws/retailTransaction/v45/credit.asmx?WSDL', array('trace' => true));
        //Email address is optional, but required for Kount FraudScoring
        $email = filter_var($_POST["EmailAddress"], FILTER_VALIDATE_EMAIL) ? $_POST["EmailAddress"] : "";

        $response = $client->Sale(
            array(
                'Credentials'            => array(
                    'MerchantName'           => 'Test MerchantKey',
                    'MerchantSiteId'         => 'XXXXXXXX',
                    'MerchantKey'            => 'XXXXX-XXXXX-XXXXX-XXXXX-XXXXX'
                    ),
                'PaymentData'            => array (
                    'Source'                 => 'VAULT',
                    'VaultToken'             => $token,
                    'CustomerEmailAddress'   => $email
                ),
                'Request'                    => array (
                    'InvoiceNumber'          => '123',
                    'Amount'                 => $amount,
                    'ForceDuplicate'         => 'true',
                    'RegisterNumber'         => '1',
                    'MerchantTransactionId'  => '1234',
                    'PurchaseOrderNumber'    => '12345',
                    'CustomerCode'           => '12'
                )
            )
        );
        $result = $response->SaleResult;
        $responseMessage = $result->ApprovalStatus;
        $amount = $result->Amount;
        $referenceNumber = $result->Token;
    }
?>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title>Acme Products</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet">
    <link href="./content/acme-style.css" rel="stylesheet">

    <script src="http://code.jquery.com/jquery-1.11.3.min.js" type="text/javascript"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js" type="text/javascript"></script>
    <script src="https://ecommerce.merchantware.net/v1/CayanCheckoutPlus.js" type="text/javascript"></script>
</head>
<body>

    <?php
    if(isPost($_SERVER) && $_POST["TokenHolder"]){
        requestSale($_POST["TokenHolder"], $amount);
    }
    ?>

    <div class="container">
        <div class="page-header">
            <h1>Acme Products <small>Checkout</small></h1>
        </div>
    </div>
    <div class="container margin-top-10 card-entry-form">
        <div class="panel panel-default">
            <!-- Default panel contents -->
            <div class="panel-heading">Order Details</div>
            <div class="panel-body">
                $<?php echo $amount; ?>
            </div>
        </div>
        <?php if($referenceNumber !== 0): ?>
       <div id="ResponseMessageContainer" class="panel panel-success">
            <div class="panel-heading">Order Results</div>
            <div class="panel-body">
                <p><strong>Status: </strong><span id="ResponseMessage">APPROVED</span></p>
                <p><strong>Reference #: </strong><span id="ResponseRef"><?php echo $referenceNumber;?></span></p>
            </div>
        </div>
        <?php else: ?>
        <div id="CheckoutPanel" class="panel panel-default">
            <!-- Default panel contents -->
            <div class="panel-heading">Card Information</div>
            <div class="panel-body">
                <div id="LoadingImage" class="form-loading" style="display:none;">
                    <img src="content/wait24.gif" />
                </div>
                <form method="post" id="PaymentForm" class="form-horizontal" role="form">
                    <div id="paymentDetails" style="display:none">
                        <div class="form-group">
                            <label for="CardHolder" id="CardholderLabel" class="control-label col-sm-3">Card Holder Name</label>
                            <div class="col-sm-9">
                                <input name="CardHolder" type="text" id="CardHolder" class="form-control" placeholder="Enter card holder name" data-cayan="cardholder" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="CardNumber" id="CardLabel" class="control-label col-sm-3">Card Number</label>
                            <div class="col-sm-9">
                                <input name="CardNumber" type="text" id="CardNumber" class="form-control" placeholder="Enter card number" data-cayan="cardnumber" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="ExpirationMonth" id="ExpirationDateLabel" class="control-label col-sm-3">Expiration Date</label>
                            <div class="col-sm-4">
                                <select name="ExpirationMonth" id="ExpirationMonth" data-cayan="expirationmonth" class="form-control">
                                    <option value="01">01 January</option>
                                    <option value="02">02 February</option>
                                    <option value="03">03 March</option>
                                    <option value="04">04 April</option>
                                    <option value="05">05 May</option>
                                    <option value="06">06 June</option>
                                    <option value="07">07 July</option>
                                    <option value="08">08 August</option>
                                    <option value="09">09 September</option>
                                    <option value="10">10 October</option>
                                    <option value="11">11 November</option>
                                    <option selected="selected" value="12">12 December</option>
                                </select>
                            </div>
                            <div class="col-sm-5">
                                <select name="ExpirationYear" id="ExpirationYear" data-cayan="expirationyear" class="form-control">
                                    <option value="15">2015</option>
                                    <option selected="selected" value="16">2016</option>
                                    <option value="17">2017</option>
                                    <option value="18">2018</option>
                                    <option value="19">2019</option>
                                    <option value="20">2020</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="CVV" id="CVVLabel" class="control-label col-sm-3">CVV/CVS</label>
                            <div class="col-sm-9">
                                <input name="CVV" type="text" id="CVV" class="form-control" placeholder="Enter the 3 or 4 digit CVV/CVS code" data-cayan="cvv" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="StreetAddress" id="StreetAddressLabel" class="control-label col-sm-3">Street Address</label>
                            <div class="col-sm-9">
                                <input name="StreetAddress" type="text" id="StreetAddress" class="form-control" placeholder="Enter street address" data-cayan="streetaddress" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="ZipCode" id="ZipLabel" class="control-label col-sm-3">Zip code</label>
                            <div class="col-sm-9">
                                <input name="ZipCode" type="text" id="ZipCode" class="form-control" placeholder="Enter 5-digit zip-code" data-cayan="zipcode" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="EmailAddress" id="EmailLabel" class="control-label col-sm-3">Email Address</label>
                            <div class="col-sm-9">
                                <input name="EmailAddress" type="text" id="EmailAddress" class="form-control" placeholder="Enter Email Address"/>
                            </div>
                        </div>
                    </div>
                    <div class="form-actions">
                        <input type="button" name="SubmitButton" value="Complete Checkout" id="SubmitButton" class="btn btn-primary" />
                        <input type="button" name="SaleButton" value="Submit Sale" onclick="javascript:__doPostBack(&#39;SaleButton&#39;,&#39;&#39;)" id="SaleButton" class="btn btn-primary" style="display: none;" />
                    </div>
                    <div id="status" class="alert-info"></div>
                    <div id="TokenMessageContainer" class="alert" style="display:none;">
                        <span id="tokenMessage" data-cayan="tokenMessage"></span>
                    </div>
                    <input name="TokenHolder" type="text" id="TokenHolder" style="display:none;" />
                </form>
            </div>
        </div>
        <?php endif; ?>
    </div>
</body>

<script>
    // set credentials to enable use of the API.
    CayanCheckoutPlus.setWebApiKey("XXXXXXXXXXXXXXXX");

    function clearTokenMessageContainer(tokenMessageContainer) {
        tokenMessageContainer.removeClass('alert-danger');
        tokenMessageContainer.removeClass('alert-success');
        tokenMessageContainer.removeClass('alert-info');
    }

    function toggleForm() {
        $("#PaymentForm").toggle();
        $("#LoadingImage").toggle();
    }

    // client defined callback to handle the successful token response
    function HandleTokenResponse(tokenResponse) {
        var tokenHolder = $("#TokenHolder");
        if (tokenResponse.token !== "") {
            tokenHolder.val(tokenResponse.token);
            $("input#tokenHolder").val(tokenResponse.token);
        }else{
            toggleForm();
        }

        // Show "waiting" gif
        $("#SaleButtonSpan").html("<img src='content/wait24.gif' />");
        $("#PaymentForm").submit();
    }

    // client-defined callback to handle error responses
    function HandleErrorResponse(errorResponses) {
        toggleForm();
        var errorText = "";
        for (var key in errorResponses) {
            errorText += " Error Code: " + errorResponses[key].error_code + " Reason: " + errorResponses[key].reason + "\n";
        }
        alert(errorText);
    }

    function buildPaymentMethods() {
        methodData = [
          {
            supportedMethods: "basic-card",
            data: {
              supportedNetworks: ["visa", "mastercard", "discover", "amex"],
              supportedTypes: ["debit", "credit", "prepaid"],
            },
          },
        ];
        return methodData;
    }

    function buildDetails() {
        details = {
            id: "123",
            displayItems: [
                {
                    label: "Sub-total",
                    amount: { currency: "USD", value: "<?php echo $amount; ?>" },
                },
                {
                    label: "Tax",
                    amount: { currency: "USD", value: "0.00" },
                },
            ],
            shippingOptions: [{
                id: "freeShipping",
                label: "Free shipping",
                amount: {currency: "USD", value: "0.00"},
                selected: true,
            }],
            total: {
                label: "Total due",
                amount: { currency: "USD", value: "<?php echo $amount; ?>" },
            },
        };
        return details;
    }

    function buildOptions() {
        options = {
            requestPayerEmail: true,
            requestPayerName: true,
            requestPayerPhone: false,
            requestShipping: true,
        }
        return options;
    }

    function initatePayment() {
        $("#SubmitButton").val("Loading...");

        if (window.PaymentRequest) {
            methods = buildPaymentMethods();
            details = buildDetails();
            options = buildOptions();
            request = new PaymentRequest(methods, details, options);

            request.canMakePayment().then(function(canMakeAFastPayment) {
                if (canMakeAFastPayment) {
                    $("#SubmitButton").val("Fast Checkout with W3C"); // Card details Present
                } else {
                    $("#SubmitButton").val("Setup W3C Checkout"); //No card details in browser
                }
                request.addEventListener('shippingaddresschange', function(evt) {
                    evt.updateWith(Promise.resolve(details));
                });
            }).catch(function(error) {
                $("#SubmitButton").val("Checkout with W3C");
            });
        } else {
            $('#paymentDetails').toggle();
            $("#SubmitButton").val("Complete Checkout");
        }
    }

    function populateCardDetails(cardData) {
        let details = cardData.details;
        //Set card data hidden fields for Checkout API
        $('#CardHolder').val(details.cardholderName);
        $('#CardNumber').val(details.cardNumber);
        $('#ExpirationMonth').val(details.expiryMonth);
        $('#ExpirationYear').val(details.expiryYear.substr(2)); //Trim year to last 2 digits
        $('#CVV').val(details.cardSecurityCode);
        //Set address info for AVS
        $('#StreetAddress').val(details.billingAddress.addressLine);
        $('#ZipCode').val(details.billingAddress.postalCode);
        $('#EmailAddress').val(cardData.payerEmail);
    }

    initatePayment();

    // create a submit action handler on the payment form, which calls CreateToken
    $("#SubmitButton").click(function (ev) {
        toggleForm();

        if (window.PaymentRequest) {
            //Initiate W3C Payments
            request.show().then(function(Response) {
                populateCardDetails(Response);
                CayanCheckoutPlus.createPaymentToken({ success: HandleTokenResponse, error: HandleErrorResponse });
            })
            .catch(function(err) {
                $('#status').text(err);
                toggleForm();
                initatePayment();
                return;
            });
        } else {
            CayanCheckoutPlus.createPaymentToken({ success: HandleTokenResponse, error: HandleErrorResponse });
        }

        ev.preventDefault();
    });

</script>
</html>