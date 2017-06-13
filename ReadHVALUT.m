% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Reads the entire 4K HVA LUT
function [error, LUT] = ReadHVALUT(BrdNum)

    LUT = [];

    % Reset Address
    error = calllib('ppcdll', 'WriteReg', BrdNum, 6, hex2dec('80000000'));
    if (error) return; end;
    
    vector = NaN*ones(2^12,1);
    pv = libpointer('uint32Ptr', vector);
    error = calllib('ppcdll', 'ReadMem', BrdNum, 6, 0, 2^12, pv);
    if (error) return; end;
    
    LUT = double(get(pv,'Value'));
    
    % Reset Address
    error = calllib('ppcdll', 'WriteReg', BrdNum, 6, hex2dec('80000000'));

    mask = ones(2^12,1);
    mask(LUT == 2^16) = 0;
    
    LUT = (LUT + 1).*mask; % Change to 1 based addressing and Mask
    
end