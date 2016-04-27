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

}