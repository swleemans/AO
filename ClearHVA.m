% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Checks HVA Mode and Writes zeros to all actuators
% by calling the PokeDM function
function error = ClearHVA(BrdNum)

    % Check HVA Status
    [error, Mode] = GetCurrentHVAmode(BrdNum);
    if (error) return; end;

    %Clear all Actuators
    for n = 1 : Mode.size
        error = PokeDM(BrdNum, n, 0);
        if (error) return; end;
    end;

end