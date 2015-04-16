package ActionBar;

import com.example.convertor.MainActivity;
import com.example.convertor.R;

import android.app.Activity;
import android.content.Intent;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;

public class MenuActionBar extends Activity {

	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
	    MenuInflater inflater = getMenuInflater();
	    inflater.inflate(R.menu.main, menu);
	    return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
	    switch (item.getItemId()) {
	        case R.id.action_logout:
	        	logout();
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
	
}
