#ifndef IPHONE_H
#define IPHONE_H


namespace qrscan
{
    namespace iphone
    {
        void InitializeIPhone();
        bool Decode();
        bool Encode(const char* content, int type, int width, int height);
    }
}


#endif
