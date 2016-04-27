package qrscan;

import flash.events.Event;
import flash.events.EventDispatcher;

class QRScanEventDispatcher extends EventDispatcher {

	public function new() {
		super();
	}

	public function encodeSuccess(format: String, path: String) {
		trace("encodeSuccess " + path);
		openfl.Lib.current.stage.dispatchEvent(new QRScanEncodeEvent(QRScanEncodeEvent.BARCODE_GENERATED, format, path));
	}

	public function decodeSuccess(format: String, data: String) {
		trace("decodeSuccess " + data);
		openfl.Lib.current.stage.dispatchEvent(new QRScanDecodeEvent(QRScanDecodeEvent.BARCODE_SCANNED, format, data));
	}

	public function error(msg: String) {
		trace("error " + msg);
		openfl.Lib.current.stage.dispatchEvent(new QRScanDecodeEvent(QRScanDecodeEvent.BARCODE_SCAN_CANCELLED, "", msg));
	}
}