#ifndef _dso_2090usb_H_
#define _dso_2090usb_H_

#include <windows.h>

struct ControlStruct
{
    WORD TriggerSource;
    WORD ChannelSelect;
    WORD TIMEBASE;
    WORD TriggerAddress;
    WORD DataLength;
    WORD BufferSize;
    WORD IsAlt;
};

struct LeversStruct
{
    WORD Ch1Lever;
    WORD Ch2Lever;
    WORD Ch1TrigLever;
    WORD Ch2TrigLever;
    WORD ExtTrigLever;
};

//Function For Hardware

extern long   dsoCaptureStart(WORD);
extern WORD   dsoChannelInGND(WORD, WORD);
extern WORD   dsoGetCaptureState(WORD, short*);
extern WORD   dsoGetChannelData(WORD, WORD, WORD, WORD , WORD*, WORD*, struct ControlStruct*, short, short);
extern char   dsoForceTrigger(WORD);
extern WORD   dsoSearchDevice(WORD);
extern WORD   dsoSetFilt(WORD, WORD, WORD, WORD);
extern long   dsoSetOffset(WORD ,struct LeversStruct* ,WORD ,WORD ,WORD ,WORD* );
extern WORD   dsoSetTriggerAndSampleRate(WORD, WORD ,struct ControlStruct*);
extern WORD   dsoSetVoltageAndCoupling(WORD, WORD, WORD, WORD, WORD, WORD);
extern long   dsoTriggerEnabled(WORD);
extern WORD   dsoGetChannelLevel(WORD, WORD*);

#endif
