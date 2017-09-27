package bbpos.com.androidposemulator;

import android.app.Fragment;
import android.content.ComponentName;
import android.content.Intent;
import android.os.Bundle;
import android.os.Parcel;
import android.preference.PreferenceManager;
import android.support.annotation.Nullable;
import android.support.v4.os.ResultReceiver;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class SignatureFragment extends Fragment implements View.OnClickListener{
    EditText et_request_id;
    EditText et_title;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_signature, container, false);

    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        et_request_id = view.findViewById(R.id.request_id);
        et_title = view.findViewById(R.id.title);
        Button btn_send = view.findViewById(R.id.send);

        btn_send.setOnClickListener(this);
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.send:
                if (et_request_id.getText().toString().isEmpty()) {
                    Toast.makeText(getActivity().getApplicationContext(), "Please enter request ID", Toast.LENGTH_LONG).show();
                    break;
                }

                if (et_title.getText().toString().isEmpty()) {
                    Toast.makeText(getActivity().getApplicationContext(), "Please enter title", Toast.LENGTH_LONG).show();
                    break;
                }

                sendGetSignature();
                break;
        }
    }

    private void sendGetSignature(){
        String URI = PreferenceManager.getDefaultSharedPreferences(getActivity().getApplicationContext()).getString("getSignatureVer", getString(R.string.version1)) + "/pos";

        Intent intent = new Intent(MainActivity.REQUEST_ACTION);
        intent.putExtra("ResultReceiverID",MainActivity.RECEIVERID);
        intent.putExtra("Action", "GetSignature");
        intent.putExtra("RequestID", et_request_id.getText().toString());
        intent.putExtra("Title", et_title.getText().toString());
        intent.putExtra("Format", PreferenceManager.getDefaultSharedPreferences(getActivity().getApplicationContext()).getString("format", getString(R.string.XML)));
        intent.putExtra("URI", URI);
        getActivity().sendBroadcast(intent);


    }

}
