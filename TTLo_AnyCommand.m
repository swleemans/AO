% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Sets the TTL output to pulse on any command
% 12 ns Clock Cycles
function error = TTLo_AnyCommand(BrdNum, Pulse_usecs)

    if (Pulse_usecs < 0 || Pulse_usecs > 700)
        error = 1017;
        return;
    end;
    
    if (Pulse_usecs > 0)
        % Set Pulse Width
        error = calllib('ppcdll', 'WriteReg', BrdNum, 23, round(Pulse_usecs*10^-6/12e-9));
        if (error)
            return;
        end;
        % Set Any Command (FVAL and DVAL are '1')
        error = calllib('ppcdll', 'WriteReg', BrdNum, 22, 2^31);
    else
        % Set Any Command (FVAL and DVAL are '1')
        error = calllib('ppcdll', 'WriteReg', BrdNum, 22, 0);
    end;
end
    
    