#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "QRScan.h"


using namespace qrscan;



static value qrscan_decode()
{
    return alloc_bool(Decode());
}
DEFINE_PRIM (qrscan_decode, 0);

static value qrscan_encode(value content, value type, value width, value height)
{
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
