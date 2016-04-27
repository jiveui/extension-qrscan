package qrscan;

import flash.events.Event;

class QRScanEncodeEvent extends Event {
    public static var BARCODE_GENERATED = "generated";

    public var format : String;
    public var path : String;

    public function new(type:String, format:String, path:String) {
        super(type, true, true);
        
        this.format = format;
        this.path = path;
    }

	public override function clone() : Event {
		return new QRScanEncodeEvent(type, format, path);
	}
}
