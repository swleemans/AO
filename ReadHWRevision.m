% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Reads the FPGA HW Revision
function [error HWRev] = ReadHWRevision(BrdNum)

    HWRev = 'Unknown';

    data = libpointer('uint32Ptr', 0);
    error = calllib('ppcdll', 'ReadReg', BrdNum, 0, data);
	if (error == 0)    
        HWRev = dec2hex(data.value,8);
    end;

end