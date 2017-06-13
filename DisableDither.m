% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Disables the Dither Hardware.
function error = DisableDither(BrdNum)
    error = calllib('ppcdll', 'WriteReg', BrdNum, 8, 0);
end