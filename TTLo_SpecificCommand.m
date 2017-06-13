% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Sets the TTL output to pulse on a specific command to a any dac channel
% 12 ns Clock Cycles
function error = TTLo_SpecificCommand(BrdNum, dac_cmd, Pulse_usecs)

    if (Pulse_usecs < 0 || Pulse_usecs > 700)
        error = 1017;
        return;
    end;
    
    % DAC command limits
    if (dac_cmd < 0 || dac_cmd > 65535)
        error = 1019;
        return;
    end;
    
    if (Pulse_usecs > 0)
        % Set Pulse Width
        error = calllib('ppcdll', 'WriteReg', BrdNum, 23, round(Pulse_usecs*10^-6/12e-9));
        if (error)
            return;
        end;
        % Set Specific dac command
        error = calllib('ppcdll', 'WriteReg', BrdNum, 21, dac_cmd);
        if (error)
            return;
        end;
        error = calllib('ppcdll', 'WriteReg', BrdNum, 22, 2^31+2);
    else
        % Set Specific dac command
        error = calllib('ppcdll', 'WriteReg', BrdNum, 21, dac_cmd);
        if (error)
            return;
        end;
        error = calllib('ppcdll', 'WriteReg', BrdNum, 22, 2);
    end;
end