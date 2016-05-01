package org.haxe.extension;


import android.graphics.Bitmap;
import android.os.Bundle;
import android.util.Log;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;

import java.io.File;
import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.Map;

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
public class QRScanEncode extends Extension {

	public static class MatrixToImageResult {
		public Boolean result;
		public String path;

		public MatrixToImageResult(Boolean result, String path) {
			this.result = result;
			this.path = path;
		}
	}

	public static void encode(java.lang.String content, int type, int width, int height) {

		MobileDevice.DisableBackButton();

		try {
			Map<EncodeHintType, Object> hints = new HashMap<>();
			BarcodeFormat format = BarcodeFormat.QR_CODE;
			switch (type) {
				case 0:
					format = BarcodeFormat.AZTEC;
					break;

				case 1:
					format = BarcodeFormat.CODABAR;
					break;

				case 2:
					format = BarcodeFormat.CODE_39;
					break;

				case 3:
					format = BarcodeFormat.CODE_93;
					break;

				case 4:
					format = BarcodeFormat.CODE_128;
					break;

				case 5:
					format = BarcodeFormat.DATA_MATRIX;
					break;

				case 6:
					format = BarcodeFormat.EAN_8;
					break;

				case 7:
					format = BarcodeFormat.EAN_13;
					break;

				case 8:
					format = BarcodeFormat.ITF;
					break;

				case 9:
					format = BarcodeFormat.MAXICODE;
					break;

				case 10:
					format = BarcodeFormat.PDF_417;
					break;

				case 11:
					format = BarcodeFormat.QR_CODE;
					break;

				case 12:
					format = BarcodeFormat.RSS_14;
					break;

				case 13:
					format = BarcodeFormat.RSS_EXPANDED;
					break;

				case 14:
					format = BarcodeFormat.UPC_A;
					break;

				case 15:
					format = BarcodeFormat.UPC_E;
					break;

				case 16:
					format = BarcodeFormat.UPC_EAN_EXTENSION;
					break;
			}
			Trace.Info(format.toString() + " generation start");
			BitMatrix matrix = new MultiFormatWriter().encode(content, format, width, height, hints);

			MatrixToImageResult image = matrixToImage(matrix, format);
			HaxeCallback.DispatchEventToHaxe("qrscan.QRScanEvent",
					new Object[]{
							"generated",
							format.toString(),
							image.path
					});
		} catch (Exception e) {
			Log.d("trace", e.toString());
		}
	}

	private static MatrixToImageResult matrixToImage(BitMatrix matrix, BarcodeFormat type) {
		if (matrix != null) {
			try {
				int width = matrix.getWidth();
				int height = matrix.getHeight();
				Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.RGB_565);

				int onColor = 0xFF000000;
				int offColor = 0xFFFFFFFF;
				int[] pixels = new int[width * height];
				int index = 0;
				for (int y = 0; y < height; y++) {
					for (int x = 0; x < width; x++) {
						pixels[index++] = matrix.get(x, y) ? onColor : offColor;
					}
				}
				bitmap.setPixels(pixels, 0, width, 0, 0, width, height);

				File file = new File(Extension.mainContext.getApplicationInfo().dataDir, "code_" + type.toString() + ".jpg");
				FileOutputStream out = new FileOutputStream(file);
				if (bitmap.compress(Bitmap.CompressFormat.PNG, 100, out)) {
					out.flush();
					out.close();
					return new MatrixToImageResult(true, file.getAbsolutePath());
				} else
					return new MatrixToImageResult(false, null);
			} catch (Exception e) {
				e.printStackTrace();
				return new MatrixToImageResult(false, null);
			}
		}
		return new MatrixToImageResult(false, null);
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
