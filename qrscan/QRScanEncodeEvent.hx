package qrscan;

import flash.events.Event;


class QRScanEncodeEvent extends Event {
    public static inline var BARCODE_GENERATED = "generated";

    public var codeType(default, null) : String = null;
    public var codeValue(default, null) : Bool = false;
    public var codePath(default, null) : String = null;

    public function new(type:String, ?codeType:String, ?codeValue:Bool, ?codePath:String) {
        super(type, true, true);

        this.codeType = codeType;
        this.codeValue = codeValue;
        this.codePath = codePath;
    }

	public override function clone() : Event {
		return new QRScanEncodeEvent(type, codeType, codeValue, codePath);
	}

	public override function toString() : String {
        var s = "[QRScanEncodeEvent type=" + type;
        s += " codeType=" + codeType + " codeValue=" + codeValue + " codePath=" + codePath;
        s += "]";
        return s;
	}
}
