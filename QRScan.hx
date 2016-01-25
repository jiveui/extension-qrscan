package;

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
	
	#if (android && openfl)
	private static var qrscan_scan_jni = JNI.createStaticMethod ("org.haxe.extension.QRScan", "scan", "()V");
	#end

	public static function Initialize() : Void {
		ExtensionKit.Initialize();
	}

	public static function scan () {

		var resultJNI = qrscan_scan_jni();
		
	}

}
