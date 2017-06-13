% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Checks HVA Mode and Writes same value to all actuators
% by calling the PokeDM function
function error = SetHVA(BrdNum, Value)

    % Check HVA Status
    [error, Mode] = GetCurrentHVAmode(BrdNum);
    
    for n = 1 : Mode.size
        error = PokeDM(BrdNum, n, Value);
        if (error) return; end;
    end;
    
end