% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Reads the HVA Status from the CameraLink CC lines
%   D(0) = CC1 = High Voltage On
%   D(1) = CC2 = Data Dropped
%   D(2) = CC3 = DACs Busy
%   D(3) = CC4 = Any Error Since Power On
function [error HVAstatus] = ReadHVAccStatus(BrdNum)

    HVAstatus = [];

    % Check HVA Status
    [error, Mode] = GetCurrentHVAmode(BrdNum);
    if (error) return; end;

    if (Mode.use_camlink == 1)
        data = libpointer('uint32Ptr', 0);
        error = calllib('ppcdll', 'ReadReg', BrdNum, 12, data);
        if (error) return; end;
    
        HVAstatus.high_voltage_on = double(~bitand(data.value,1));
        HVAstatus.data_dropped = double(bitshift(bitand(data.value,2),-1));
        HVAstatus.DACs_busy = double(bitshift(bitand(data.value,4),-2));
        HVAstatus.any_error = double(bitshift(bitand(data.value,8),-3));
    end;

end