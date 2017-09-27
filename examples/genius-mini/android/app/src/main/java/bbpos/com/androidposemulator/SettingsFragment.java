package bbpos.com.androidposemulator;

import android.app.Fragment;
import android.os.Bundle;
import android.preference.EditTextPreference;
import android.preference.Preference;
import android.preference.PreferenceFragment;

public class SettingsFragment extends PreferenceFragment {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        addPreferencesFromResource(R.xml.preferences);

        final EditTextPreference merchantName =  (EditTextPreference) findPreference("merchantName");
        merchantName.setSummary(getPreferenceManager().getSharedPreferences().getString("merchantName", getString(R.string.merchant_name)));
        merchantName.setOnPreferenceChangeListener(new Preference.OnPreferenceChangeListener() {

            @Override
            public boolean onPreferenceChange(Preference preference,
                                              Object newValue) {
                merchantName.setSummary(newValue.toString());

                return true;
            }
        });

        final EditTextPreference merchantSiteId =  (EditTextPreference) findPreference("merchantSiteId");
        merchantSiteId.setSummary(getPreferenceManager().getSharedPreferences().getString("merchantSiteId", getString(R.string.merchant_name)));
        merchantSiteId.setOnPreferenceChangeListener(new Preference.OnPreferenceChangeListener() {

            @Override
            public boolean onPreferenceChange(Preference preference,
                                              Object newValue) {
                merchantSiteId.setSummary(newValue.toString());

                return true;
            }
        });

        final EditTextPreference merchantKey =  (EditTextPreference) findPreference("merchantKey");
        merchantKey.setSummary(getPreferenceManager().getSharedPreferences().getString("merchantKey", getString(R.string.merchant_name)));
        merchantKey.setOnPreferenceChangeListener(new Preference.OnPreferenceChangeListener() {

            @Override
            public boolean onPreferenceChange(Preference preference,
                                              Object newValue) {
                merchantKey.setSummary(newValue.toString());

                return true;
            }
        });

        final EditTextPreference getAgreementVer =  (EditTextPreference) findPreference("getAgreementVer");
        getAgreementVer.setSummary(getPreferenceManager().getSharedPreferences().getString("getAgreementVer", getString(R.string.version1)));
        getAgreementVer.setOnPreferenceChangeListener(new Preference.OnPreferenceChangeListener() {

            @Override
            public boolean onPreferenceChange(Preference preference,
                                              Object newValue) {
                getAgreementVer.setSummary(newValue.toString());

                return true;
            }
        });

        final EditTextPreference getSignatureVer =  (EditTextPreference) findPreference("getSignatureVer");
        getSignatureVer.setSummary(getPreferenceManager().getSharedPreferences().getString("getSignatureVer", getString(R.string.version1)));
        getSignatureVer.setOnPreferenceChangeListener(new Preference.OnPreferenceChangeListener() {

            @Override
            public boolean onPreferenceChange(Preference preference,
                                              Object newValue) {
                getSignatureVer.setSummary(newValue.toString());

                return true;
            }
        });

        final EditTextPreference saleVer =  (EditTextPreference) findPreference("saleVer");
        saleVer.setSummary(getPreferenceManager().getSharedPreferences().getString("saleVer", getString(R.string.version2)));
        saleVer.setOnPreferenceChangeListener(new Preference.OnPreferenceChangeListener() {

            @Override
            public boolean onPreferenceChange(Preference preference,
                                              Object newValue) {
                saleVer.setSummary(newValue.toString());

                return true;
            }
        });

        final EditTextPreference keyedEntryVer =  (EditTextPreference) findPreference("keyedEntryVer");
        keyedEntryVer.setSummary(getPreferenceManager().getSharedPreferences().getString("keyedEntryVer", getString(R.string.version1)));
        keyedEntryVer.setOnPreferenceChangeListener(new Preference.OnPreferenceChangeListener() {

            @Override
            public boolean onPreferenceChange(Preference preference,
                                              Object newValue) {
                keyedEntryVer.setSummary(newValue.toString());

                return true;
            }
        });

        final EditTextPreference cancelVer =  (EditTextPreference) findPreference("cancelVer");
        cancelVer.setSummary(getPreferenceManager().getSharedPreferences().getString("cancelVer", getString(R.string.version1)));
        cancelVer.setOnPreferenceChangeListener(new Preference.OnPreferenceChangeListener() {

            @Override
            public boolean onPreferenceChange(Preference preference,
                                              Object newValue) {
                cancelVer.setSummary(newValue.toString());

                return true;
            }
        });

        final EditTextPreference format =  (EditTextPreference) findPreference("format");
        format.setSummary(getPreferenceManager().getSharedPreferences().getString("format", getString(R.string.XML)));
        format.setOnPreferenceChangeListener(new Preference.OnPreferenceChangeListener() {

            @Override
            public boolean onPreferenceChange(Preference preference,
                                              Object newValue) {
                format.setSummary(newValue.toString());

                return true;
            }
        });
    }

}
