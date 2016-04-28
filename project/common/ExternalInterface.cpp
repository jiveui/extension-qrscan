#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "QRScan.h"

#define safe_alloc_string(a) (a!=NULL?alloc_string(a):NULL)

using namespace qrscan;

AutoGCRoot* callback = 0;

static value qrscan_decode(value onCallback)
{
	callback = new AutoGCRoot(onCallback);
    return alloc_bool(Decode());
}
DEFINE_PRIM (qrscan_decode, 0);

static value qrscan_encode(value content, value type, value width, value height, value onCallback)
{
	callback = new AutoGCRoot(onCallback);
    return alloc_bool(Encode(val_string(content), val_int(type), val_int(width), val_int(height)));
}
DEFINE_PRIM (qrscan_encode, 4);


extern "C" void qrscan_main ()
{
    val_int(0); // Fix Neko init
}
DEFINE_ENTRY_POINT(qrscan_main);



extern "C" int qrscan_register_prims()
{
    Initialize();
    return 0;
}

extern "C" void sendCallback(const char* type, const char* format, const char* data) {
	value o = alloc_empty_object();
	alloc_field(o, val_id("type"), safe_alloc_string(type));
	alloc_field(o, val_id("format"), safe_alloc_string(format));
	alloc_field(o, val_id("data"), safe_alloc_string(data));
	val_call1(callback->get(), o);
}