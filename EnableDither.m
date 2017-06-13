% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Enables the Dither Hardware at the desired frame rate.
% This controlls the rate in which frame are sent to the
% HVA and does not represent the oscillation frequency
% you will see on the mirror.  The oscillation frequency
% is dependant on both the Frame Rate and Waveform pattern.
% If the Rate is zero then the Dither is just disabled.
function error = EnableDither(BrdNum, FRRate)

    if (FRRate < 0)
        error = 1012;
        return;
    end;
    if (FRRate == 0)
        % Disables Dither
        error = calllib('ppcdll', 'WriteReg', BrdNum, 8, 0);
        if (error)
            return;
        end;
    else
        period = round(1/FRRate / 16e-9); % 62.5 MHz Clock
        if (period == 0 || period > 2^32-1)
            error = 1012;
            return;
        end;
        error = calllib('ppcdll', 'WriteReg', BrdNum, 8, period);
    end;
end