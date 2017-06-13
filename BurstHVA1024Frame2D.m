% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Writes a 2D frame of data to the HVA
% Use this function when the result of your algorithm is a 32x32 array.
% If the HVA orientation is not correct Use SetHVAorientation to
% have the hardware automatically rotate the DM.
% This function assumes that the HVA is set up in the correct HVA1024
% mode.  If the card is opened in an alternate HVA mode
% then the function AbortFramedData must be called to end the
% frame and recover.
function [ error ] = BurstHVA1024Frame2D(BrdNum, DMData)
    Cmds32 = typecast(uint16(reshape(DMData',1024,1)),'uint32');
    pv = libpointer('uint32Ptr', Cmds32);
    error = calllib('ppcdll', 'WriteMemBurst', BrdNum, 32, 512, pv);
end