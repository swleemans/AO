% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Writes a 1D frame of data to the HVA
% Use this function when the result of your algorithm is a 1x169 array.
% If the HVA orientation is not correct Use SetHVAorientation to
% have the hardware automatically rotate the DM.
% This function assumes that the HVA is set up in the correct HVA137
% mode.  If the card is opened in an alternate mode then the function
% AbortFramedData must be called to end the frame and recover.
function [ error ] = BurstHVA137Frame1D(BrdNum, DMData)
    Cmds32 = typecast(uint16(vertcat(DMData, 0)),'uint32');
    pv = libpointer('uint32Ptr', Cmds32);
    error = calllib('ppcdll', 'WriteMemBurst', BrdNum, 32, 85, pv);
end