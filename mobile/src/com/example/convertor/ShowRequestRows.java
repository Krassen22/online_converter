package com.example.convertor;

import http.HttpPostRequest;

import java.util.ArrayList;

import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;
import android.widget.Toast;

public class ShowRequestRows extends ArrayAdapter<String[]> {

	final static int FILES 	= 0;
	final static int IDS 	= 1;
	final static int STATUS = 2;
	final static int CONVERTED_FILE = 3;
	
	public ShowRequestRows(Context context, ArrayList<String[]> files) {
		super(context, R.layout.request_row, files);
	}

	@SuppressLint("ViewHolder")
	@Override
	public View getView(final int position, View row, ViewGroup parent) {
		LayoutInflater inflater = LayoutInflater.from(getContext());
		View request_row_view = inflater.inflate(R.layout.request_row, parent, false);
		
		TextView file_name = (TextView) request_row_view.findViewById(R.id.irequest_row_file);
		TextView id = (TextView) request_row_view.findViewById(R.id.irequest_row_id);
		TextView status = (TextView) request_row_view.findViewById(R.id.irequest_row_status);
		TextView converted_file = (TextView) request_row_view.findViewById(R.id.irequest_row_converted_file);
		
		file_name.setText(getItem(position)[FILES]);
		id.append(getItem(position)[IDS]);
		status.append(getItem(position)[STATUS]);
		converted_file.append(getItem(position)[CONVERTED_FILE]);
		
		final String download_url = getContext().getResources().getString(R.string.website_url_download);
		
		if(!getItem(position)[STATUS].equals("Error")) {
			request_row_view.setOnTouchListener(new View.OnTouchListener() {
				@SuppressLint("ClickableViewAccessibility")
				@Override
				public boolean onTouch(View v, MotionEvent event) {
					String url = download_url + getItem(position)[CONVERTED_FILE];
					startBrowser(url);	
					return false;
				}
			});
		}
		
		request_row_view.setOnLongClickListener(new View.OnLongClickListener() {
			@Override
			public boolean onLongClick(View v) {
				AlertDialog.Builder builder = new AlertDialog.Builder(getContext());
				builder.setMessage("Delete request?")
						.setNegativeButton(R.string.dialog_cancel, null)
						.setPositiveButton(R.string.dialog_ok, new AlertDialog.OnClickListener() {
							@Override
							public void onClick(DialogInterface dialog, int which) {
								String id = getItem(position)[IDS];
								String uri = getContext().getResources().getString(R.string.website_url_delete_request);
								DeleteRequest http = new DeleteRequest();
								http.execute(uri, id);
							}
						});
				builder.create().show();
				return false;
			}
		});
		
		file_name.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				startBrowser(getItem(position)[FILES]);
			}
		});
		
		return request_row_view;
	}

	public void startBrowser(String url) {
		try { 
			Intent i = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
			getContext().startActivity(i);
		} catch(ActivityNotFoundException e) {
			Toast.makeText(getContext(), "Unvalid url", Toast.LENGTH_LONG).show();
		}
	}
	
	class DeleteRequest extends AsyncTask<String, String, String>{
		@Override
		protected String doInBackground(String... thread_params) {
			JSONObject params = new JSONObject();
			try {
				params.put("token", get_token());
				params.put("id", thread_params[1]);
			} catch (JSONException e) {
				e.printStackTrace();
			}
			
			HttpPostRequest.make_request(thread_params[0], params);
			return null;
		}
		
	}
	
	private String get_token() {
		return getContext().getSharedPreferences("token", Context.MODE_PRIVATE).getString("token", "");
	}
}
