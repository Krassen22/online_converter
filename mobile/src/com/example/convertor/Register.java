package com.example.convertor;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;



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
        //submit_button.setOnClickListener(register_listener);
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

//    View.OnClickListener register_listener = new View.OnClickListener() {
//        public void onClick(View v) {
//            get_input();
//            String url = getResources().getString(R.string.website_url_login); // register
//            new HttpRequest().execute(url);
//        }
//    }
};