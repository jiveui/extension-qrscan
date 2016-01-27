#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "QRScan.h"


using namespace qrscan;



static value qrscan_scan()
{
    return alloc_bool(Scan());
}
DEFINE_PRIM (qrscan_scan, 0);



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
