% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Automatically flattens the 2D 13x13 HVA commands and writes to HVA
% Use this function when the result of your algorithm is a 13x13 array.
% If the HVA orientation is not correct Use SetHVAorientation to
% have the hardware automatically rotate the DM.
% This function assumes that the HVA is set up in the correct HVA137
% mode.  If the card is opened in an alternate mode then the function
% AbortFramedData must be called to end the frame and recover.
function [ error ] = BurstHVA137Frame2D(BrdNum, DMData)
    Cmds32 = typecast(uint16(vertcat(reshape(DMData',169,1),0)),'uint32');
    pv = libpointer('uint32Ptr', Cmds32);
    error = calllib('ppcdll', 'WriteMemBurst', BrdNum, 32, 85, pv);
end