package qrscan;

import flash.events.Event;
import flash.events.EventDispatcher;

class QRScanEventDispatcher extends EventDispatcher {

	public function new() {
		super();
	}

	public function encodeSuccess(format: String, data: String) {
		trace("encodeSuccess " + data);
		openfl.Lib.current.stage.dispatchEvent(new QRScanEvent(QRScanEvent.BARCODE_GENERATED, format, data));
	}

	public function decodeSuccess(format: String, data: String) {
		trace("decodeSuccess " + data);
		openfl.Lib.current.stage.dispatchEvent(new QRScanEvent(QRScanEvent.BARCODE_SCANNED, format, data));
	}

	public function error(data: String) {
		trace("error " + data);
		openfl.Lib.current.stage.dispatchEvent(new QRScanEvent(QRScanEvent.BARCODE_SCAN_CANCELLED, "", data));
	}

	// iOS callback
	public static function notifyListeners(event: Dynamic) {
		var type = Std.string(Reflect.field(event, "type"));
		var format = Std.string(Reflect.field(event, "format"));
		var data = Std.string(Reflect.field(event, "data"));

		switch (type) {
			case QRScanEvent.BARCODE_GENERATED:
				trace(type);

			case QRScanEvent.BARCODE_SCANNED:
				trace(type);

			case QRScanEvent.BARCODE_SCAN_CANCELLED:
				trace(type);

			default:
		}
	}
}