% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Reads the Status Bits back from the KILO HVA
% D2 = FIFO Half Full
% D1 = Address Out of Range
% D0 = DAC Overflow
function [error, Status] = ReadKiloStatus(BrdNum)

    Status = [];

    % Check HVA Status
    [error, Mode] = GetCurrentHVAmode(BrdNum);
    if (error) return; end;
    
    if (Mode.use_fiber == 1 && Mode.fiber_mode == 1)
        data = libpointer('uint32Ptr', 0);
        error = calllib('ppcdll', 'ReadReg', BrdNum, 24, data);
        if (error) return; end;
    
        Status.dac_overflow = double(~bitand(data.value,1));
        Status.addr_outofrange = double(bitshift(bitand(data.value,2),-1));
        Status.fifo_half_full = double(bitshift(bitand(data.value,4),-2));
    end;

end