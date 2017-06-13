% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Reads the Fiber Link State
function [error, LinkState] = ReadFiberLinkState(BrdNum)

    LinkState = 0;

    data = libpointer('uint32Ptr', 0);
    error = calllib('ppcdll', 'ReadReg', BrdNum, 15, data);
	if (error)
        return;
    end;
    
    LinkState.sfp_present = double(~bitand(data.value,1));
    LinkState.sfp_txfault = double(bitshift(bitand(data.value,2),-1));
    LinkState.sfp_los = double(bitshift(bitand(data.value,4),-2));
    LinkState.channel_up = 0;
    LinkState.lane_up = 0;
    LinkState.soft_error = 0;
    LinkState.hard_error = 0;
    if (LinkState.sfp_present == 1 && LinkState.sfp_txfault == 0 && LinkState.sfp_los == 0)
        LinkState.channel_up = double(bitshift(bitand(data.value,8),-3));
        LinkState.lane_up = double(bitshift(bitand(data.value,16),-4));
        LinkState.soft_error = double(bitshift(bitand(data.value,32),-5));
        LinkState.hard_error = double(bitshift(bitand(data.value,64),-6));
    end;

end