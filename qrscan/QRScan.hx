package qrscan;

import extensionkit.ExtensionKit;
import haxe.Utf8;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

#if (android && openfl)
import openfl.utils.JNI;
#end


class QRScan {
	
	private static var qrscan_scan_jni : Dynamic;
	private static var qrscan_scan : Dynamic;
	private static var qrscan_generate_jni : Dynamic;
	private static var qrscan_generate : Dynamic;

	public static function Initialize() : Void {
		try {
			#if android
			qrscan_scan_jni = JNI.createStaticMethod("org/haxe/extension/QRScanDecode", "decode", "()V");
			qrscan_generate_jni = JNI.createStaticMethod("org/haxe/extension/QRScanEncode", "encode", "(Ljava/lang/String;Ljava/lang/String;II)V");
			#end

			#if cpp
			qrscan_scan = Lib.load("qrscan", "scan", 0);
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

	public static function generate(content:String, type:String, width:Int, height:Int) {

		#if android

		qrscan_generate_jni(content, type, width, height);
		
		#elseif (cpp && mobile)

		qrscan_generate();

		#end

	}

}
