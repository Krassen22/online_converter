package com.example.convertor;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import http.HttpPostRequest;
import android.os.AsyncTask;

public class MainActivity extends Activity {

	Button submit_button;
	Button submit_reg_button;
	EditText username_et;
	EditText password_et;

	private String username;
	private String password;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.login_screen);
		check_if_logged_in();

		setViews();

		submit_button.setOnClickListener(login_listener);
		submit_reg_button.setOnClickListener(register_listener);
	}

	private void check_if_logged_in() {
		SharedPreferences settings = getSharedPreferences("token", MODE_PRIVATE);
		if(!settings.getString("token", "").isEmpty())
			login();
	}

	private void setViews() {
		submit_button = (Button) findViewById(R.id.login_button);
		submit_reg_button = (Button) findViewById(R.id.register_button);
		username_et = (EditText) findViewById(R.id.login_username);
		password_et = (EditText) findViewById(R.id.login_password);
	}

	private void get_input() {
		username = username_et.getText().toString();
		password = password_et.getText().toString();
	}

	View.OnClickListener login_listener = new View.OnClickListener() {
		public void onClick(View v) {
			get_input();
			String url = getResources().getString(R.string.website_url_login);
			new HttpRequest().execute(url);
		}
	};

	View.OnClickListener register_listener = new View.OnClickListener() {
		public void onClick(View v) {
			Intent i = new Intent(getApplicationContext(), Register.class);
			startActivity(i);
		}
	};

	private void handle_action(String token) {
		if(token.equals("Error")) {
			Toast.makeText(getApplicationContext(), "Wrong password or username", Toast.LENGTH_LONG).show();
		} else {
			set_token(token);
			login();
		}
	}

	private void login() {
		Intent i = new Intent(getApplicationContext(), ShowRequests.class);
		startActivity(i);
		finish();
	}

	private void set_token(String token) {
		SharedPreferences settings = getSharedPreferences("token", MODE_PRIVATE);
		Editor edit = settings.edit();
		edit.putString("token", token);
		edit.apply();
	}

	public class HttpRequest extends AsyncTask<String, String, String> {

	    @Override
	    protected String doInBackground(String... uri) {
	    	JSONObject params = new JSONObject();
	    	try {
				params.put("email", username);
		    	params.put("password", password);
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
