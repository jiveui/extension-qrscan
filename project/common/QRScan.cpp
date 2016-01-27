#include "QRScan.h"
#include "../iphone/IPhone.h"


namespace qrscan
{
    void Initialize()
    {
        #ifdef IPHONE
        iphone::InitializeIPhone();
        #endif
    }

    bool Scan()
    {
        #ifdef IPHONE
        return iphone::Scan();
        #else
        return false;
        #endif
    }
}
