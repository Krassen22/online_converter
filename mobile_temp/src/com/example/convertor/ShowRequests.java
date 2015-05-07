package com.example.convertor;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import http.HttpGetRequest;
import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.Toast;

public class ShowRequests extends Activity {
	ListView requests_list;
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
	    MenuInflater inflater = getMenuInflater();
	    inflater.inflate(R.menu.show_request_menu, menu);
	    return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
	    switch (item.getItemId()) {
	        case R.id.action_logout:
	        	logout();
	            return true;
	        case R.id.action_new:
	        	create_new();
	        	return true;
	        case R.id.action_update:
	        	update_content();
	        	return true;
	        default:
	            return super.onOptionsItemSelected(item);
	    }
	}
	
	private void logout() {
        getSharedPreferences("token", MODE_PRIVATE).edit().clear().apply();
        startActivity(new Intent(getApplicationContext(), MainActivity.class));
        finish();
	}
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.show_requests);
		init();
	}

	private void init() {
		requests_list = (ListView) findViewById(R.id.requests_list_view);
		
		new GetRequestsHttp().execute(get_token());
	}
	
	private void create_new() {
		Intent i = new Intent(ShowRequests.this, CreateRequest.class);
		startActivity(i);
	};
	
	private void update_content() {
		new GetRequestsHttp().execute(get_token());
	};

	private String get_token() {
		return getSharedPreferences("token", MODE_PRIVATE).getString("token", "");
	}
	
	private class GetRequestsHttp extends AsyncTask<String, String, String> {

		@Override
		protected String doInBackground(String... params) {
			String url = getResources().getString(R.string.website_url_update_requests);
			url = url.concat(params[0]+ "/0");
			return HttpGetRequest.make_request(url);
		}

		@Override
		protected void onPostExecute(String response) {
			super.onPostExecute(response);
			ArrayList<String[]> result;
			try {
				result = parse_json(response);
			} catch (JSONException e) {
				e.printStackTrace();
				show_message("Error");
				return;
			}
			ListAdapter list = new ShowRequestRows(ShowRequests.this, result);
			requests_list.setAdapter(list);
		}

		private ArrayList<String[]> parse_json(String response) throws JSONException {
			JSONObject json = new JSONObject("{ body :" + response + "}");
			ArrayList<String[]> response_array = new ArrayList<String[]>();
			JSONArray arr = json.getJSONArray("body");
			for(int i = 0; i < arr.length(); i++) {
				JSONObject current = arr.getJSONObject(i);
				String[] curr = { 
					current.getString("source_url").toString(),
					current.getString("id").toString(),
					current.getString("status").toString(),
					current.getString("download_file").toString()
				};
				response_array.add(curr);
			}
			return response_array;
		}
		
		private void show_message(String message) {
			Toast.makeText(getApplicationContext(), message, Toast.LENGTH_SHORT).show();
		}
		
		
	}
	
}
