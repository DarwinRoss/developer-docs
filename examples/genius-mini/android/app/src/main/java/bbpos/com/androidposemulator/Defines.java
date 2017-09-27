package bbpos.com.androidposemulator;

public class Defines {

    public enum KeyedEntryPaymentType {
        NIL,
        GIFT
    }

    public enum POSAction {
        CreateTransaction, //Start transaction
        InitiateKeyedSale, //Manual entry card info; deprecated
        InitiateKeyedEntry,//Manual entry card info
        StatusCall, //Check CED status

        //LID related below
        StartOrder,
        AddItem,
        DiscountItem,
        DeleteItem,
        DeleteAllItem,
        UpdateItem,
        UpdateTotal,
        OrderSummary,
        OrderSnapshot,

        //Generic
        Cancel,
        EndOrder,


        //Other
        GetSignature,
        GetAgreement,
        GetCustomerInput,
        QueryByMessageID,

        //Unrecognised action
        Unknown,
    }
}
