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

    bool Decode()
    {
        #ifdef IPHONE
        return iphone::Decode();
        #else
        return false;
        #endif
    }
    
    bool Encode(const char* content, int type, int width, int height)
    {
        #ifdef IPHONE
        return iphone::Encode(content, type, width, height);
        #else
        return false;
        #endif
    }
}
