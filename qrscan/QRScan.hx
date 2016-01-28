package qrscan;

import extensionkit.ExtensionKit;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

#if (android && openfl)
import openfl.utils.JNI;
#end


class QRScan {
	

	public static function Initialize() : Void {
		try {
			#if android
			private static var qrscan_scan_jni = JNI.createStaticMethod ("org.haxe.extension.QRScan", "scan", "()V");
			#end

			#if cpp
			private static var qrscan_scan = Lib.load("qrscan", "scan", 0);
			#end
		} catch(e:Dynamic) {
			trace(e);
		}

		ExtensionKit.Initialize();
	}

	public static function scan() {

		#if android

		qrscan_scan_jni();
		
		#elseif (cpp && mobile)

		qrscan_scan();

		#end

	}

}