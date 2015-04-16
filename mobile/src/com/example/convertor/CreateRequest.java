package com.example.convertor;

import org.json.JSONException;
import org.json.JSONObject;

import http.HttpPostRequest;
import ActionBar.MenuActionBar;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class CreateRequest extends MenuActionBar {

	Button submit;
	EditText url;
	EditText format;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.create_request);
		init();
	}
	
	private void init() {
		submit = (Button) findViewById(R.id.create_request_submit);
		url = (EditText) findViewById(R.id.create_request_url);
		format = (EditText) findViewById(R.id.create_request_format);
		submit.setOnClickListener(on_submit_listener);
	}
	
	private String get_token() {
		return getSharedPreferences("token", MODE_PRIVATE).getString("token", "");
	}
	
	private String get_url() {
		return getResources().getString(R.string.website_url_make_request);
	}
	
	View.OnClickListener on_submit_listener = new View.OnClickListener() {
		@Override
		public void onClick(View v) {
			new HttpRequest().execute(get_url(), url.getText().toString(), format.getText().toString());
			finish();
		}
	};
	
	private class HttpRequest extends AsyncTask<String, String, String>{

		@Override
		protected String doInBackground(String... params) {
			JSONObject args = new JSONObject();
			JSONObject json = new JSONObject();
			try {
				args.put("source_url", params[1]);
				args.put("convert_to", params[2]);
				json.put("token", get_token());
				json.put("request", args);
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return HttpPostRequest.make_request(params[0], json);
		}

		@Override
		protected void onPostExecute(String result) {
			super.onPostExecute(result);
			Toast.makeText(getApplicationContext(), result, Toast.LENGTH_LONG).show();
		}
		
	}
	
}
