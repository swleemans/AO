gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DSO_2090_OpeningFcn, ...
                   'gui_OutputFcn',  @DSO_2090_OutputFcn, ...
                   'gui_LayoutFcn',  @DSO_2090_LayoutFcn, ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
function DSO_2090_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DSO_2090 (see VARARGIN)

% Choose default command line output for DSO_2090
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
end

function varargout = DSO_2090_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

if ~libisloaded('dso_2090usb')
    loadlibrary( 'dso_2090usb.dll', 'dso_2090usb.h' );
end

handles.DeviceIndex = 0;
[dsoSearchDevice_1] = calllib('dso_2090usb', 'dsoSearchDevice', handles.DeviceIndex);
% this function can be used to make a error dialog when the device isn't
% connected.

handles.Ch1_Filt = 0;
handles.Ch2_Filt = 0;
handles.Trigger_Filt = 0;
handles.Trigger_Slope = 1;
handles.Control_Data1.TriggerSource = 1; 
handles.Control_Data1.ChannelSelect = 2; 
handles.Control_Data1.TIMEBASE = 12;
handles.Control_Data1.TriggerAddress = 50; 
handles.Control_Data1.DataLength = 1; 
handles.Control_Data1.BufferSize = 10; 
handles.Control_Data1.IsAlt = 0;
handles.Ch1_att = 6;
handles.Ch2_att = 6;
handles.Ch1_ACDC = 0;
handles.Ch2_ACDC = 0;


[dsoSetTriggerAndSampleRate_1 Control_Data1] =calllib( 'dso_2090usb' , 'dsoSetTriggerAndSampleRate', handles.DeviceIndex, handles.Trigger_Slope, libstruct('ControlStruct',handles.Control_Data1));

[dsoSetFilt_1] = calllib('dso_2090usb', 'dsoSetFilt', handles.DeviceIndex, handles.Ch1_Filt, handles.Ch2_Filt, handles.Trigger_Filt);

handles.TriggerSource=handles.Control_Data1.TriggerSource;

[dsoSetVoltageAndCoupling_1 ] =calllib('dso_2090usb','dsoSetVoltageAndCoupling', handles.DeviceIndex, handles.Ch1_att, handles.Ch2_att, handles.Ch1_ACDC, handles.Ch2_ACDC, handles.TriggerSource);

handles.Levers.Ch1Lever = 190;
handles.Levers.Ch1TrigLever = 23;
handles.Levers.Ch2Lever = 190;
handles.Levers.Ch2TrigLever = 40;
handles.Levers.ExtTrigLever = 0;
handles.Level = uint16([50 164 45 154 45 156 50 162 45 154 45 156 50 164 45 154 45 156 20 134 28 137 35 146 20 134 28 137 30 146 20 134 25 137 30 146 0 254 2202 242 170 30 170 30 170 30 170 30 170 30 170 30 170 30 160 30 180 40 180 90 4095]);

[dsoSetOffset_1 handles.Levers handles.Level ] =calllib('dso_2090usb', 'dsoSetOffset', handles.DeviceIndex, libstruct('LeversStruct',handles.Levers) , handles.Ch1_Filt, handles.Ch2_Filt, handles.TriggerSource, handles.Level );

handles.flag_auto_co = 0;
handles.Ram_Addr = 0;
handles.pos_trig = 50;
handles.ch1_data = uint16(zeros(1,30000));
handles.ch2_data = uint16(zeros(1,30000));
handles.calData = 1;
handles.ChannelData_1=uint16(zeros(1,30000));
handles.ChannelData_2=uint16(zeros(1,30000));

guidata(hObject,handles);
end
