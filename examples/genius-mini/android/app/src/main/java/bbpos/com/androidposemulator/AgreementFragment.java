package bbpos.com.androidposemulator;

import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class AgreementFragment extends Fragment implements View.OnClickListener{
    EditText et_request_id;
    EditText et_title;
    EditText et_accept_label;
    EditText et_decline_label;
    EditText et_agreement_text;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_agreement, container, false);

    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        et_request_id = view.findViewById(R.id.request_id);
        et_title = view.findViewById(R.id.title);
        et_accept_label = view.findViewById(R.id.accept_label);
        et_decline_label = view.findViewById(R.id.decline_label);
        et_agreement_text = view.findViewById(R.id.agreement_text);
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

                if (et_accept_label.getText().toString().isEmpty()) {
                    Toast.makeText(getActivity().getApplicationContext(), "Please enter accept label", Toast.LENGTH_LONG).show();
                    break;
                }

                if (et_decline_label.getText().toString().isEmpty()) {
                    Toast.makeText(getActivity().getApplicationContext(), "Please enter decline label", Toast.LENGTH_LONG).show();
                    break;
                }

                if (et_agreement_text.getText().toString().isEmpty()) {
                    Toast.makeText(getActivity().getApplicationContext(), "Please enter agreement text", Toast.LENGTH_LONG).show();
                    break;
                }

                sendGetAgreement();
                break;
        }
    }

    private void sendGetAgreement(){
        et_request_id.getText();
        et_title.getText();
        et_accept_label.getText();
        et_decline_label.getText();
        et_agreement_text.getText();

        String URI = PreferenceManager.getDefaultSharedPreferences(getActivity().getApplicationContext()).getString("getAgreementVer", getString(R.string.version1)) + "/pos";

        Intent intent = new Intent(MainActivity.REQUEST_ACTION);
        intent.putExtra("ResultReceiverID",MainActivity.RECEIVERID);
        intent.putExtra("Action", "GetAgreement");
        intent.putExtra("RequestID", et_request_id.getText().toString());
        intent.putExtra("Title", et_title.getText().toString());
        intent.putExtra("AgreementText", et_agreement_text.getText().toString());
        intent.putExtra("AcceptLabel", et_accept_label.getText().toString());
        intent.putExtra("DeclineLabel", et_decline_label.getText().toString());
        intent.putExtra("Format", PreferenceManager.getDefaultSharedPreferences(getActivity().getApplicationContext()).getString("format", getString(R.string.XML)));
        intent.putExtra("URI", URI);
        getActivity().sendBroadcast(intent);
    }
}
