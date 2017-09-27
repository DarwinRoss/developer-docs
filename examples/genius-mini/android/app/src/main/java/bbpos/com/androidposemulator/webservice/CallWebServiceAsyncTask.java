package bbpos.com.androidposemulator.webservice;

import android.app.Activity;
import android.app.Fragment;
import android.os.AsyncTask;
import android.util.Log;

import org.ksoap2.SoapEnvelope;
import org.ksoap2.serialization.PropertyInfo;
import org.ksoap2.serialization.SoapObject;
import org.ksoap2.serialization.SoapSerializationEnvelope;
import org.ksoap2.transport.HttpTransportSE;

import java.util.HashMap;

public class CallWebServiceAsyncTask extends AsyncTask<Void, Void, Void> {
    private static final String TAG = "LogEng";

    SoapObject soapObject;
    public CallWebServiceAsyncTask(Fragment fr, SoapObject soapObject){
        this.soapObject = soapObject;
        resultCallback = (PostWebServerResult)fr;
    }
    String resultString;
    PostWebServerResult resultCallback;
    HashMap<String,String> resultMap = new HashMap<>();


    @Override
    protected void onPreExecute() {
        super.onPreExecute();
    }

    @Override
    protected Void doInBackground(Void... voids) {
        sendSoapRequest(soapObject);
        return null;
    }

    @Override
    protected void onPostExecute(Void aVoid) {
        super.onPostExecute(aVoid);
    }

    public void sendSoapRequest(SoapObject Request) {
        String SOAP_ACTION = "http://transport.merchantware.net/v4/CreateTransaction";
        String URL = "https://transport.merchantware.net/v4/transportService.asmx";

        try {
            SoapSerializationEnvelope soapEnvelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
            soapEnvelope.dotNet = true;
            soapEnvelope.setOutputSoapObject(Request);


            HttpTransportSE transport = new HttpTransportSE(URL);

            transport.debug = true;
            transport.call(SOAP_ACTION, soapEnvelope);
            Log.i(TAG, "Request: " + transport.requestDump);

            resultString = transport.responseDump;
            SoapObject value = ( SoapObject ) soapEnvelope.getResponse();
            Log.i(TAG, "Result TransportKey: " + value.getPrimitiveProperty("TransportKey"));

            Log.i(TAG, "Result resultString: " + resultString);

            resultMap.put("TransportKey", value.getPrimitiveProperty("TransportKey").toString());
            resultMap.put("ValidationKey", value.getPrimitiveProperty("ValidationKey").toString());
            resultCallback.onResult(resultMap);
        } catch (Exception ex) {
            Log.e(TAG, "Error: " + ex.getLocalizedMessage());
        }
    }
}
