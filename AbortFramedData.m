% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Aborts the Frame.  This function is required if
% the incorrect amount of data is written to the card using
% one of the BurstHVAXXXFrameYD functions.
% This occurs if the HVA was Setup in the incorrect mode.
% Or is the incorrect number of commands was written.
function [ error ] = AbortFramedData(BrdNum)
    error = calllib('ppcdll', 'WriteReg', BrdNum, 3, hex2dec('80000000'));
end