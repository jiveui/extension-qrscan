package org.haxe.extension;


import android.app.Activity;
import android.content.res.AssetManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import com.google.zxing.integration.android.*;
import org.haxe.extension.extensionkit.*;


/* 
	You can use the Android Extension class in order to hook
	into the Android activity lifecycle. This is not required
	for standard Java code, this is designed for when you need
	deeper integration.
	
	You can access additional references from the Extension class,
	depending on your needs:
	
	- Extension.assetManager (android.content.res.AssetManager)
	- Extension.callbackHandler (android.os.Handler)
	- Extension.mainActivity (android.app.Activity)
	- Extension.mainContext (android.content.Context)
	- Extension.mainView (android.view.View)
	
	You can also make references to static or instance methods
	and properties on Java classes. These classes can be included 
	as single files using <java path="to/File.java" /> within your
	project, or use the full Android Library Project format (such
	as this example) in order to include your own AndroidManifest
	data, additional dependencies, etc.
	
	These are also optional, though this example shows a static
	function for performing a single task, like returning a value
	back to Haxe from Java.
*/
public class QRScanDecode extends Extension {

	public static void decode() {

		Trace.Info("QRScanDecode -> decode");

		MobileDevice.DisableBackButton();

		try {
			IntentIntegrator intentIntegrator = new IntentIntegrator(Extension.mainActivity);
			intentIntegrator.setBeepEnabled(false);
			intentIntegrator.initiateScan();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@Override
	public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
		try {
			IntentResult scanResult = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);

			if (scanResult != null && scanResult.getContents() != null) {
				Trace.Info("Barcode scan complete.");

				HaxeCallback.DispatchEventToHaxe("qrscan.QRScanDecodeEvent",
						new Object[]{
								"scanned",
								scanResult.getFormatName().replace('_', '-'),
								scanResult.getContents()
						});
			} else {
				Trace.Info("Barcode scan cancelled or failed.");

				HaxeCallback.DispatchEventToHaxe("qrscan.QRScanDecodeEvent",
						new Object[]{
								"cancelled"
						});
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return super.onActivityResult(requestCode, resultCode, data);
	}
	
	
	/**
	 * Called when the activity is starting.
	 */
	public void onCreate (Bundle savedInstanceState) {
		
		
		
	}
	
	
	/**
	 * Perform any final cleanup before an activity is destroyed.
	 */
	public void onDestroy () {
		
		
		
	}
	
	
	/**
	 * Called as part of the activity lifecycle when an activity is going into
	 * the background, but has not (yet) been killed.
	 */
	public void onPause () {
		
		
		
	}
	
	
	/**
	 * Called after {@link #onStop} when the current activity is being 
	 * re-displayed to the user (the user has navigated back to it).
	 */
	public void onRestart () {
		
		
		
	}
	
	
	/**
	 * Called after {@link #onRestart}, or {@link #onPause}, for your activity 
	 * to start interacting with the user.
	 */
	public void onResume () {

		MobileDevice.EnableBackButton();
		
	}
	
	
	/**
	 * Called after {@link #onCreate} &mdash; or after {@link #onRestart} when  
	 * the activity had been stopped, but is now again being displayed to the 
	 * user.
	 */
	public void onStart () {
		
		
		
	}
	
	
	/**
	 * Called when the activity is no longer visible to the user, because 
	 * another activity has been resumed and is covering this one. 
	 */
	public void onStop () {
		
		
		
	}
	
	
}
