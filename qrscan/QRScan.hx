package qrscan;

import qrscan.BarcodeFormat;
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
				qrscan_generate_jni = JNI.createStaticMethod("org/haxe/extension/QRScanEncode", "encode", "(Ljava/lang/String;III)V");
			
			#end

			#if cpp

				qrscan_scan = Lib.load("qrscan", "decode", 0);
				qrscan_generate = Lib.load("qrscan", "encode", 4);
			
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

	public static function generate(content:String, type:BarcodeFormat, width:Int, height:Int) {

		#if android

			qrscan_generate_jni(content, formatsToInt(type), width, height);
		
		#elseif (cpp && mobile)

			var t = 0;
			switch(type) {
				case "QR_CODE": t = 0;
				case "EAN_13": t = 1;
			} 
			qrscan_generate(content, t, width, height); // TODO fix it

		#end

	}

	static function formatsToInt(type: BarcodeFormat) : Int {
		switch (type) {
			case AZTEC: return 0;
		    case CODABAR: return 1; 
		    case CODE_39: return 2;
		    case CODE_93: return 3;
		    case CODE_128: return 4;
		    case DATA_MATRIX: return 5;
		    case EAN_8: return 6;
		    case EAN_13: return 7;
		    case ITF: return 8;
		    case MAXICODE: return 9;
		    case PDF_417: return 10;
		    case QR_CODE: return 11;
		    case RSS_14: return 12;
		    case RSS_EXPANDED: return 13;
		    case UPC_A: return 14;
		    case UPC_E: return 15;
		    case UPC_EAN_EXTENSION: return 16;
		}
		return -1;
	}

}
