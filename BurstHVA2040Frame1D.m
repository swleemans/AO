% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Writes a 1D frame of data to the HVA
% Use this function when the result of your algorithm is a 2040x1 array.
% This function assumes that the HVA is set up in the correct HVA2040
% mode.  If the card is opened in an alternate HVA mode
% then the function AbortFramedData must be called to end the
% frame and recover.
function [ error ] = BurstHVA2040Frame1D(BrdNum, DMData)
    Cmds32 = typecast(uint16(DMData),'uint32');
    pv = libpointer('uint32Ptr', Cmds32);
    error = calllib('ppcdll', 'WriteMemBurst', BrdNum, 32, 1020, pv);
end