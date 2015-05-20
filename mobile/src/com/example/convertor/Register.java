package com.example.convertor;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import http.HttpPostRequest;


/**
 * Created by dimmat97 on 5/8/15.
 */
public class Register extends Activity {

    Button submit_button;
    EditText username_et;
    EditText password_et;
    EditText password_conf_et;

    private String username;
    private String password;
    private String conf_password;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.register_screen);

        setViews();
        submit_button.setOnClickListener(register_listener);
    }

    private void get_input() {
        username = username_et.getText().toString();
        password = password_et.getText().toString();
        conf_password = password_conf_et.getText().toString();
    }
    private void setViews() {
        submit_button = (Button) findViewById(R.id.account_button);
        username_et = (EditText) findViewById(R.id.register_username);
        password_et = (EditText) findViewById(R.id.register_password);
        password_conf_et = (EditText) findViewById(R.id.register_password_confirm);
    }

    View.OnClickListener register_listener = new View.OnClickListener() {
        public void onClick(View v) {
            get_input();
            String url = getResources().getString(R.string.website_url_register); // register
            new HttpRequest().execute(url);
        }
    };

    private void handle_action(String message) {
        if(!message.equals("Success")) {
            Toast.makeText(getApplicationContext(), message, Toast.LENGTH_LONG).show();
        } else {
            Toast.makeText(getApplicationContext(), "Successfully registered", Toast.LENGTH_LONG).show();
            finish();
        }
    }

    public class HttpRequest extends AsyncTask<String, String, String> {

        @Override
        protected String doInBackground(String... uri) {
            JSONObject params = new JSONObject();
            try {
                params.put("email", username);
                params.put("password", password);
                params.put("confirm_password", conf_password);
            } catch (JSONException e) {
                e.printStackTrace();
            }
            return HttpPostRequest.make_request(uri[0], params);
        }

        @Override
        protected void onPostExecute(String result) {
            super.onPostExecute(result);
            handle_action(result);
        }
    }
}