% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Sets the TTL output equal to the internal FVAL signal
% 12 ns Clock Cycles
function error = TTLo_FVAL(BrdNum)
    error = calllib('ppcdll', 'WriteReg', BrdNum, 22, 4);
end