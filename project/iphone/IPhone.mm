#include <UIKit/UIKit.h>
#include <objc/runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include "IPhone.h"
#include "ExtensionKit.h"
#include "ExtensionKitIPhone.h"
#include "ZBarSDK/Headers/ZBarSDK/ZBarSDK.h"
#include "ZXingObjC/ZXingObjC.h"
#include "ZXingObjC/core/ZXBarcodeFormat.h"


//
// Function that dynamically implements the NMEAppDelegate.supportedInterfaceOrientationsForWindow
// callback to allow portrait orientation even if app only supports landscape.
// This is required as barcode scanning camera simulator needs portrait mode.
//
static NSUInteger ApplicationSupportedInterfaceOrientationsForWindow(id self, SEL _cmd, UIApplication* application, UIWindow* window)
{
	return UIInterfaceOrientationMaskAll;
}


//
// Delegate for notifications from the ZBar library.
//
@interface ZBarReaderDelegate : NSObject <ZBarReaderDelegate>
{
}
- (void) dismissReader:(UIImagePickerController*)reader;
@end

@implementation ZBarReaderDelegate
- (void) imagePickerController:(UIImagePickerController*)reader didFinishPickingMediaWithInfo:(NSDictionary*)info
{
	// get the decode results
	id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
	ZBarSymbol* symbol = nil;
	for (symbol in results)
		// just grab the first barcode
		break;

	// do something useful with the barcode data
	printf("Scanned barcode: type=%s, value=%s\n", [symbol.typeName UTF8String], [symbol.data UTF8String]);

	extensionkit::DispatchEventToHaxe("qrscan.QRScanDecodeEvent",
									  extensionkit::CSTRING, "scanned",
									  extensionkit::CSTRING, [symbol.typeName UTF8String],
									  extensionkit::CSTRING, [symbol.data UTF8String],
									  extensionkit::CEND);

	// dismiss with a slight delay to avoid conflicting with the reader view still updating
	[self performSelector:@selector(dismissReader:) withObject:reader afterDelay:1.0f];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)reader
{
	printf("Barcode scanning cancelled.\n");

	extensionkit::DispatchEventToHaxe("qrscan.QRScanDecodeEvent",
									  extensionkit::CSTRING, "cancelled",
									  extensionkit::CEND);

	[self dismissReader:reader];
}

- (void) dismissReader:(UIImagePickerController*)reader
{
	// dismiss the controller (NB dismiss from the *reader*!)
	((ZBarReaderViewController*) reader).readerDelegate = nil;
	[reader dismissViewControllerAnimated:YES completion:nil];
	[self release];
}
@end


namespace qrscan
{
	namespace iphone
	{
		void InitializeIPhone()
		{
			// Ensure we support portrait orientation else UIImagePickerController crashes
			class_addMethod(NSClassFromString(@"NMEAppDelegate"),
							@selector(application:supportedInterfaceOrientationsForWindow:),
							(IMP) ApplicationSupportedInterfaceOrientationsForWindow,
							"I@:@@");
		}

		bool Decode()
		{
			// Get our topmost view controller
			UIViewController* topViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;

			// Present a barcode reader that scans from the camera feed
			ZBarReaderViewController *reader = [ZBarReaderViewController new];
			reader.readerDelegate = [[ZBarReaderDelegate alloc] init];
			reader.supportedOrientationsMask = ZBarOrientationMaskAll;

			ZBarImageScanner* scanner = reader.scanner;
			// TODO: (optional) additional reader configuration here
			// EXAMPLE: disable rarely used I2/5 to improve performance
			[scanner setSymbology: ZBAR_I25
					 config: ZBAR_CFG_ENABLE
					 to: 0];

			// present and release the controller
			[topViewController presentViewController:reader animated:YES completion:nil];
			[reader release];

			return true;
		}
		
		bool Encode(const char* content, int type, int width, int height)
		{
			NSError *error = nil;
			ZXBarcodeFormat format = kBarcodeFormatQRCode;
			switch(type) {
				case 0: // QR Code
					format = kBarcodeFormatQRCode;
					break;
					
				case 1: // EAN-13
					format = kBarcodeFormatEan13;
					break;
			}
			ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
			ZXBitMatrix* result = [writer 
				encode:[NSString stringWithFormat:@"%s", content]
				format:format
				width:width
				height:height
				error:&error];
			
			if (result) {
				CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
				UIImage *uiImage = [[UIImage alloc] initWithCGImage:image];
				
				printf("Encoding success: type=%d\n", type);
				
				// Write to JPEG
				int dataLength;
				FILE* tempFile;
				const void* data = extensionkit::iphone::UIImageAsPNGBytes(uiImage, &dataLength);
				const char* tempFilePath = extensionkit::CreateTemporaryFile(&tempFile);

				if (tempFilePath != NULL)
				{	
				    printf("Savig success: (%d bytes) to %s\n", dataLength, tempFilePath);
				    fwrite(data, 1, dataLength, tempFile);
				    fclose(tempFile);

					extensionkit::DispatchEventToHaxe("qrscan.QRScanEncodeEvent",
												  extensionkit::CSTRING, "generated",
												  extensionkit::CINT, type,
												  extensionkit::CINT, 1,
												  extensionkit::CSTRING, tempFilePath,
												  extensionkit::CEND);
				}
				else
				{
					printf("Saving failed: ERROR! Unable to create temporary file.\n");

					extensionkit::DispatchEventToHaxe("qrscan.QRScanEncodeEvent",
												  extensionkit::CSTRING, "generated",
												  extensionkit::CINT, type,
												  extensionkit::CINT, 0,
												  extensionkit::CSTRING, tempFilePath,
												  extensionkit::CEND);
				}
			} else {
				printf("Encoding failed");

				extensionkit::DispatchEventToHaxe("qrscan.QRScanEncodeEvent",
										  extensionkit::CSTRING, "generated",
										  extensionkit::CINT, type,
										  extensionkit::CINT, 0,
										  extensionkit::CSTRING, "",
										  extensionkit::CEND);
			}
			
			return true;
		}
	}
}
