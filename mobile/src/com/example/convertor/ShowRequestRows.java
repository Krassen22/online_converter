package com.example.convertor;

import java.util.ArrayList;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

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
					Intent i = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
					getContext().startActivity(i);	
					return false;
				}
			});
		}
		
		file_name.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent i = new Intent(Intent.ACTION_VIEW, Uri.parse(getItem(position)[FILES]));
				getContext().startActivity(i);	
			}
		});
		
		return request_row_view;
	}

}
