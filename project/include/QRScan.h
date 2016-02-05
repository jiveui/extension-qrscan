#ifndef QRSCAN_H
#define QRSCAN_H


namespace qrscan
{
    void Initialize();
    bool Decode();
    bool Encode(const char* content, int type, int width, int height);
}


#endif
