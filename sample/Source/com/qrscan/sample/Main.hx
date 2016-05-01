package com.qrscan.sample;


import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.display.BitmapData;
import openfl.utils.*;
import qrscan.*;


class Main extends Sprite {
	
	
	public function new () {

		trace("Sample running");
		
		super ();

		var button : Sprite = new Sprite();
		button.graphics.beginFill(0x90C3D4);
        button.graphics.drawRoundRect(0, 0, 400, 100, 10, 10);
        button.graphics.endFill();
        button.x = button.y = 20;
        button.addEventListener(MouseEvent.CLICK, onClick);
        // var caption: TextField = new TextField();
        // caption.text = "SCAN";
        // caption.x = 100;
        // caption.y = 20;

        // button.addChild(caption);
        addChild(button);

        // var text : TextField = new TextField();
        // text.text = "Result: ";
        // text.x = 20;
        // text.y = 200;
        // var tf = new TextFormat();
        // tf.size = 36;
        // text.defaultTextFormat = tf;
        // text.autoSize = openfl.text.TextFieldAutoSize.LEFT;
        // addChild(text);

        var button2 : Sprite = new Sprite();
        button2.graphics.beginFill(0x90C3D4);
        button2.graphics.drawRoundRect(0, 0, 400, 100, 10, 10);
        button2.graphics.endFill();
        button2.x = 20;
        button2.y = 300;
        button2.addEventListener(MouseEvent.CLICK, onClick2);
        // var caption2: TextField = new TextField();
        // caption2.text = "GENERATE";
        // caption2.x = 100;
        // caption2.y = 300;

        // button2.addChild(caption2);
        addChild(button2);

 
		
		stage.addEventListener(QRScanEvent.BARCODE_SCANNED, function(e) { trace(e); /*text.text = "Result: " + e.data;*/ } );
        stage.addEventListener(QRScanEvent.BARCODE_SCAN_CANCELLED, function(e) { trace(e); });
        stage.addEventListener(QRScanEvent.BARCODE_GENERATED, function(e) { trace(e); loadImage(e.data); });

	}

    function loadImage(path: String) {
        /*var bytes:openfl.utils.ByteArray = ByteArray.readFile(path);
        var bitmapData = BitmapData.loadFromBytes(bytes);
        this.addChild(new flash.display.Bitmap(bitmapData));*/
    }
	
	function onClick(event : MouseEvent) {
        QRScan.Initialize();
		QRScan.scan();
    }

    function onClick2(event : MouseEvent) {
        QRScan.Initialize();
        var size = Math.ceil(Math.min(openfl.Lib.current.stage.stageWidth, openfl.Lib.current.stage.stageHeight));
        QRScan.generate("SOME TEXT to encode", qrscan.BarcodeFormat.QR_CODE, size, size);
    }
}