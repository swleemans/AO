% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Sets the TTL output to pulse on any command to a specific dac channel
% 12 ns Clock Cycles
function error = TTLo_SpecificActuator(BrdNum, dac_ch, Pulse_usecs)

    if (Pulse_usecs < 0 || Pulse_usecs > 700)
        error = 1017;
        return;
    end;
    
    % DAC channel space
    if (dac_ch < 0 || dac_ch > 4095)
        error = 1018;
        return;
    end;
    
    if (Pulse_usecs > 0)
        % Set Pulse Width
        error = calllib('ppcdll', 'WriteReg', BrdNum, 23, round(Pulse_usecs*10^-6/12e-9));
        if (error)
            return;
        end;
        % Set Specific dac channel
        error = calllib('ppcdll', 'WriteReg', BrdNum, 21, dac_ch*2^16);
        if (error)
            return;
        end;
        error = calllib('ppcdll', 'WriteReg', BrdNum, 22, 2^31+1);
    else
        % Set Specific dac channel
        error = calllib('ppcdll', 'WriteReg', BrdNum, 21, dac_ch*2^16);
        if (error)
            return;
        end;
        error = calllib('ppcdll', 'WriteReg', BrdNum, 22, 1);
    end;
end