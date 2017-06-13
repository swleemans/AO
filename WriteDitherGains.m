% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Writes the Dither Gains to Memory
% The Gain Array must be 1D and the proper size
% for the HVA mode.
function error = WriteDitherGains(BrdNum, Array1D)

    if (max(Array1D(:)) > 65535)
        error = 1009;
        return;
    end;

    if (min(Array1D(:)) < 0)
        error = 1009;
        return;
    end;
    
    % Get Current HVA Mode
    [error, Mode] = GetCurrentHVAmode(BrdNum);
    if (error) return; end;
    
    if (length(Array1D) ~= Mode.size)
        error = 1008;
        return;
    end;

    % Reset Address
    error = calllib('ppcdll', 'WriteReg', BrdNum, 10, hex2dec('80000000'));
    if (error) return; end;
    
    pv = libpointer('uint32Ptr', Array1D);
    error = calllib('ppcdll', 'WriteMem', BrdNum, 10, 0, Mode.size, pv);
    if (error) return; end;
    
    % Reset Address
    error = calllib('ppcdll', 'WriteReg', BrdNum, 10, hex2dec('80000000'));
    if (error) return; end;
    
end