% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Asks the Driver for Number of PCIeCLout Devices.
% Boards can be accessed from 1 to N
function [error NumDev] = GetNumDevices

    NumDev = 0;

    data = libpointer('uint16Ptr', 0);
    error = calllib('ppcdll', 'GetNumDevices', data);
	if (error)
        return;
    end;
    
    NumDev = data.value;

end