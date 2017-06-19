#ifndef SDK2090DLL_HEADFILE_H
#define SDK2090DLL_HEADFILE_H
//Here is the Headfile of SDK2090DLL
#include <windows.h>
#include<stdio.h>
#ifndef DLL_API
#define DLL_API extern "C" __declspec(dllimport)
#endif
#define WINAPI __stdcall

struct PictureRange
{
    WORD Width;
    WORD Hight;
    WORD Left;
    WORD Right;
    WORD Top;
    WORD Bottom;
};

struct ControlStruct
{
    WORD TriggerSource;
    WORD ChannelSelect;
    WORD TIMEBASE;
    WORD TriggerAddress;
	WORD BufferSize;
    WORD IsAlt;
};

struct LineColor
{
	WORD R;
	WORD G;
	WORD B;
};

struct AutosetStruct
{
	WORD WhichChannel;
	WORD Ch1Voltage;
	WORD Ch2Voltage;
	WORD Ch1Timebase;
	WORD Ch2Timebase;
	WORD Ch1InGND;
	WORD Ch2InGND;
	WORD Ch1Enabled;
	WORD Ch2Enabled;
};

struct StateStruct
{
	WORD Ch1Filt;
	WORD Ch2Filt;
	WORD TriggerFilt;
	WORD TriggerMode;
	WORD TriggerSlope;
};

struct LeversStruct
{
    WORD Ch1Lever;
    WORD Ch2Lever;
    WORD Ch1TrigLever;
    WORD Ch2TrigLever;
    WORD ExtTrigLever;
};

struct TimeStruct{
	double Timer;
	double Time;
	double ScrollTime;
	double ScrollStart;
};

//Function For Hardware
DLL_API WORD WINAPI sdSearchDevice(WORD DeviceIndex);
DLL_API WORD WINAPI sdGetChannelLevel(WORD DeviceIndex,WORD * pZeroLevel,WORD nLen);
DLL_API WORD WINAPI sdSetTriggerAndSampleRate(WORD DeviceIndex,WORD Trigger_Slope,struct ControlStruct *Control_Data1,WORD TrigFilt);
DLL_API WORD WINAPI sdSetVoltageAndCoupling(WORD DeviceIndex,WORD Ch1_Att,WORD Ch2_Att,WORD Ch1_ACDC,WORD Ch2_ACDC,WORD TriggerSource);
DLL_API WORD WINAPI sdSetFilt(WORD DeviceIndex,struct StateStruct *FiltAndTrigger);
DLL_API WORD WINAPI sdSetOffset(WORD DeviceIndex,struct LeversStruct * Levers,WORD Ch1_Att,WORD Ch2_Att,WORD TriggerSource,	WORD * level);
DLL_API WORD WINAPI sdCaptureStart(WORD DeviceIndex);
DLL_API WORD WINAPI sdTriggerEnabled(WORD DeviceIndex);
DLL_API WORD WINAPI sdForceTrigger(WORD DeviceIndex);
DLL_API WORD WINAPI sdGetData(WORD DeviceIndex,WORD Ch1_Att,WORD Ch2_Att,WORD * ch1_data, WORD * ch2_data,struct ControlStruct *Control_Data1,
							  struct StateStruct *FiltAndTrigger,struct LeversStruct *levers,WORD *level,WORD StartCapture);

//Function For Software
DLL_API WORD WINAPI sdGetDataSleep(struct ControlStruct *Control_Data1);
DLL_API WORD WINAPI sdMainPanelDrawGrid(HDC hdc,struct PictureRange * view_data);
DLL_API WORD WINAPI sdGetScrollData(WORD DeviceIndex,struct ControlStruct *Control_Data1,struct LeversStruct *levers,struct TimeStruct *TimeState,
									WORD Ch1Voltage,WORD Ch2Voltage,WORD *Ch1ScrollData,WORD *Ch2ScrollData,WORD *Ch1DisplayData,
									WORD *Ch2DisplayData,WORD TriggerPosition,bool Ch1InGND,bool Ch2InGND);
DLL_API double WINAPI sdDisplaySampling(bool Ch1Enabled,bool Ch2Enabled,WORD TriggerSource,WORD Timebase,WORD BufferSize,double *time);
DLL_API WORD WINAPI sdChannelDataBuffer(struct ControlStruct *Control_Data1, WORD InterpolationLineMode,  WORD * ch_BufferData,WORD * ch_HardData);

DLL_API WORD WINAPI sdSoftFindTriggerPoint(WORD nHTriggerPosition,WORD TIMEBASE,WORD TriggerLever,WORD TriggerSlope,WORD *BufferData);
DLL_API WORD WINAPI sdSoftFindTriggerPointCopy(short nHTriggerPosition,USHORT TriggerPoint,WORD *BufferData);

DLL_API WORD WINAPI sdGetDisplayData(struct ControlStruct *Control_Data1,WORD * Ch1_DisplayData, WORD * ch_BufferData);
DLL_API WORD WINAPI sdDisplayData(HDC hdc,struct PictureRange * view_data,WORD isLine, WORD * ch1_data,struct LineColor * ch_color);
DLL_API WORD WINAPI sdChannelInGND(WORD Ch1Position, WORD *chdata);
DLL_API WORD WINAPI sdAutoset(WORD DeviceIndex,struct ControlStruct *Control_Data1,struct AutosetStruct *AutosetData,
							  struct StateStruct *FiltAndTrigger,struct LeversStruct * levers,WORD *level);

#endif


