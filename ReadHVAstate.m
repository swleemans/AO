% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Checks HVA State and Reads the current DM position.
function [ error, State ] = ReadHVAstate(BrdNum)

    State = 0;

    % Reset Address
    error = calllib('ppcdll', 'WriteReg', BrdNum, 5, hex2dec('80000000'));
    if (error) return; end;

    % Check HVA Status
    [error, Mode] = GetCurrentHVAmode(BrdNum);
    if (error) return; end;
    
    vector = NaN*ones(Mode.size,1);
    pv = libpointer('uint32Ptr', vector);
    error = calllib('ppcdll', 'ReadMem', BrdNum, 5, 0, Mode.size, pv);
    if (error) return; end;
    
    State = double(get(pv,'Value'));

    % Reset Address
    error = calllib('ppcdll', 'WriteReg', BrdNum, 5, hex2dec('80000000'));
end