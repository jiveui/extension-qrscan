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

extern "C" void sendCallback(const char* type, const char* format, const char* data);

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

	sendCallback("scanned", [symbol.typeName UTF8String], [symbol.data UTF8String]);

	// dismiss with a slight delay to avoid conflicting with the reader view still updating
	[self performSelector:@selector(dismissReader:) withObject:reader afterDelay:1.0f];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)reader
{
	printf("Barcode scanning cancelled.\n");

	sendCallback("cancelled", "", "");

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
			
			switch (type) {
				case 0:
					format = kBarcodeFormatAztec;
					break;

				case 1:
					format = kBarcodeFormatCodabar;
					break;

				case 2:
					format = kBarcodeFormatCode39;
					break;

				case 3:
					format = kBarcodeFormatCode93;
					break;

				case 4:
					format = kBarcodeFormatCode128;
					break;

				case 5:
					format = kBarcodeFormatDataMatrix;
					break;

				case 6:
					format = kBarcodeFormatEan8;
					break;

				case 7:
					format = kBarcodeFormatEan13;
					break;

				case 8:
					format = kBarcodeFormatITF;
					break;

				case 9:
					format = kBarcodeFormatMaxiCode;
					break;

				case 10:
					format = kBarcodeFormatPDF417;
					break;

				case 11:
					format = kBarcodeFormatQRCode;
					break;

				case 12:
					format = kBarcodeFormatRSS14;
					break;

				case 13:
					format = kBarcodeFormatRSSExpanded;
					break;

				case 14:
					format = kBarcodeFormatUPCA;
					break;

				case 15:
					format = kBarcodeFormatUPCE;
					break;

				case 16:
					format = kBarcodeFormatUPCEANExtension;
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
				const void* data = /*extensionkit::iphone::*/UIImageAsPNGBytes(uiImage, &dataLength);
				const char* tempFilePath = /*extensionkit::*/CreateTemporaryFile(&tempFile);

				if (tempFilePath != NULL)
				{	
				    printf("Savig success: (%d bytes) to %s\n", dataLength, tempFilePath);
				    fwrite(data, 1, dataLength, tempFile);
				    fclose(tempFile);

				    sendCallback("generated", [format UTF8String], tempFilePath);
				}
				else
				{
					printf("Saving failed: ERROR! Unable to create temporary file.\n");

				    sendCallback("generate_saving_error", [format UTF8String], tempFilePath);
				}
			} else {
				printf("Encoding failed");

				sendCallback("generate_encoding_error", [format UTF8String], "");
			}
			
			return true;
		}

		const char* CreateTemporaryFile(FILE** outFp)
        {
            NSString* tempFileTemplate = [NSTemporaryDirectory() stringByAppendingPathComponent:@"extensionkit.XXXXXX"];
            strcpy(g_filePathBuffer, [tempFileTemplate fileSystemRepresentation]);
            int fileDescriptor = mkstemp(g_filePathBuffer);
         
            if (fileDescriptor == -1)
            {
                if (outFp)
                {
                    *outFp = NULL;
                }
                
                return NULL;
            }
         
            if (outFp != NULL)
            {
                *outFp = fdopen(fileDescriptor, "w+");
            }
            else
            {
                close(fileDescriptor);
            }
            
            return g_filePathBuffer;
        }

        const void* UIImageAsPNGBytes(UIImage* src, int* outLength)
        {
            NSData* imageAsPNG = UIImagePNGRepresentation(src);
            int dataLength = [imageAsPNG length];
            const void* data = [imageAsPNG bytes];
            
            if (outLength)
            {
                *outLength = dataLength;
            }
            
            return data;
        }
	}
}
