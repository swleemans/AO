% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Reads either the current TTLi rate or the Frame Period
% software previously wrote.  Result is in Hertz.
function [error, FrameRate] = ReadSequenceRate(BrdNum)

    FrameRate = 0;

    data = libpointer('uint32Ptr', 0);
    error = calllib('ppcdll', 'ReadReg', BrdNum, 17, data);
    if (error) return; end;

    if (data.value ~= 0)
        FrameRate = 1/(double(data.value)*16e-9);
    end;
    
end