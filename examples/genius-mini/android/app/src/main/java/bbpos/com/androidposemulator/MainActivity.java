package bbpos.com.androidposemulator;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.Fragment;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.annotation.NonNull;
import android.support.design.widget.BottomNavigationView;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.widget.TextView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MainActivity extends AppCompatActivity implements SharedPreferences.OnSharedPreferenceChangeListener {

    public static final String RECEIVERID = "android.intent.action.genius.pos.result";
    public static final String REQUEST_ACTION = "android.intent.action.genius.pos.request";
    private TextView mTextMessage;
    private BroadcastReceiver intentResultReceiver;
    private int lastPauseTaskId;

    private BottomNavigationView.OnNavigationItemSelectedListener mOnNavigationItemSelectedListener
            = new BottomNavigationView.OnNavigationItemSelectedListener() {

        @Override
        public boolean onNavigationItemSelected(@NonNull MenuItem item) {
            Fragment fr;

            switch (item.getItemId()) {
                case R.id.navigation_main:
                    fr = new MainFragment();
                    replaceFragment(fr);
                    return true;
                case R.id.navigation_signature:
                    fr = new SignatureFragment();
                    replaceFragment(fr);
                    return true;
                case R.id.navigation_agreement:
                    fr = new AgreementFragment();
                    replaceFragment(fr);
                    return true;
                case R.id.navigation_settings:
                    fr = new SettingsFragment();
                    replaceFragment(fr);
                    return true;
            }
            return false;
        }

    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        RegisterDeveloperChangeListener(this);

        Fragment fragment = new MainFragment();
        replaceFragment(fragment);
        BottomNavigationView navigation = (BottomNavigationView) findViewById(R.id.navigation);
        navigation.setOnNavigationItemSelectedListener(mOnNavigationItemSelectedListener);
        
        intentResultReceiver = new BroadcastReceiver() {

            @Override
            public void onReceive(Context context, Intent intent) {

                String result = intent.getStringExtra("result");
                String description = intent.getStringExtra("description");

                showResultDialog(result);

                if (Defines.POSAction.valueOf(description) != Defines.POSAction.InitiateKeyedEntry) {
                    ActivityManager activityManager = (ActivityManager) context
                            .getSystemService(Context.ACTIVITY_SERVICE);
                    List<ActivityManager.RunningTaskInfo> rt = activityManager.getRunningTasks(Integer.MAX_VALUE);

                    activityManager.moveTaskToFront(getTaskId(), 0);
                }

            }
        };
        IntentFilter filter = new IntentFilter(RECEIVERID);
        this.registerReceiver(intentResultReceiver, filter);
    }

    private void replaceFragment(Fragment fragment) {
        FragmentManager fm = getFragmentManager();
        FragmentTransaction fragmentTransaction = fm.beginTransaction();
        fragmentTransaction.replace(R.id.content, fragment);
        fragmentTransaction.commit();
    }

    public void RegisterDeveloperChangeListener(SharedPreferences.OnSharedPreferenceChangeListener listener)
    {
        SharedPreferences developerPreference = PreferenceManager.getDefaultSharedPreferences(this.getApplicationContext());
        developerPreference.registerOnSharedPreferenceChangeListener(listener);
    }

    @Override
    public void onSharedPreferenceChanged(SharedPreferences sharedPreferences, String s) {

    }

    public void showResultDialog(String msg){
        AlertDialog.Builder builder;
        builder = new AlertDialog.Builder(this);
        builder.setTitle("Result")
                .setMessage(msg)
                .show();
    }

    @Override
    protected void onPause() {
        super.onPause();
        lastPauseTaskId = getTaskId();
    }

}
