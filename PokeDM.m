% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Checks HVA State and then pokes a single actuator
% on the DM. ActNum range is from 1 to either 144, 36, or 1024.
function error = PokeDM(BrdNum, ActNum, Data)

    % Check HVA Status
    [error, Mode] = GetCurrentHVAmode(BrdNum);
    if (error) return; end;
    
    if (ActNum > Mode.size || ActNum < 1)
        error = 1007;
        return;
    end;
    
	error = calllib('ppcdll', 'WriteReg', BrdNum, 4, (ActNum-1)*2^16 + Data);
end