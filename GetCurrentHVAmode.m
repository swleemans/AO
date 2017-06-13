% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Checks HVA State and returns the corresponding configuration.
function [error, Mode] = GetCurrentHVAmode(BrdNum)

    Mode = [];

    % Check HVA Status
    data = libpointer('uint32Ptr', 0);
    error = calllib('ppcdll', 'ReadReg', BrdNum, 1, data);
    if (error) return; end;
    
    Mode.idnum = double(bitand(data.value,uint32(hex2dec('1F'))));
    Mode.use_camlink = double(bitand(data.value,uint32(hex2dec('20'))))*2^-5;
    Mode.use_fiber = double(bitand(data.value,uint32(hex2dec('40'))))*2^-6;
    Mode.fiber_mode = double(bitand(data.value,uint32(hex2dec('80'))))*2^-7;
    Mode.burst_mode = double(bitand(data.value,uint32(hex2dec('100'))))*2^-8;
    Mode.size = double(bitand(data.value,uint32(hex2dec('FFFF0000'))))*2^-16;

end