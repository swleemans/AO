% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Writes the Dither Wavefrom to Memory
% The wave array is a 1D value between 0 and +1.
% it can be up to 2048 in length.
function error = WriteDitherWave(BrdNum, Waveform)

    % Reset Address
    error = calllib('ppcdll', 'WriteReg', BrdNum, 9, hex2dec('80000000'));
    if (error)
        return;
    end;
    
    if (length(Waveform) > 2048)
        error = 1010;
        return;
    end;
    if (max(Waveform(:)) > 1.0 || min(Waveform(:)) < 0)
        error = 1011;
        return;
    end;
    
    temp_wave = round(Waveform*2^15); % unsigned 1.15 integer
    % Insert EOW bit
    temp_wave(length(temp_wave)) = temp_wave(length(temp_wave)) + 2^16;
    
    % Reset Address
    error = calllib('ppcdll', 'WriteReg', BrdNum, 9, hex2dec('80000000'));
    if (error) return;  end;
    
    pv = libpointer('uint32Ptr', temp_wave);
    error = calllib('ppcdll', 'WriteMem', BrdNum, 9, 0, length(temp_wave), pv);
    if (error) return; end;
    
    % Reset Address
    error = calllib('ppcdll', 'WriteReg', BrdNum, 9, hex2dec('80000000'));
    if (error) return;  end;
    
end