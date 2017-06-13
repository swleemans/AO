% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Enables the Sequence Hardware
% If the FRRate is 0, then the external SMA trigger
% will be used as the Sequence rate.  If the FRRate is
% non-zero then the internal trigger generator is used
% as the sequence rate.
function error = EnableSequence(BrdNum, FRRate)

    if (FRRate < 0)
        error = 1016;
        return;
    end;
    if (FRRate == 0)
        % Disables Sequence Frame Rate
        error = calllib('ppcdll', 'WriteReg', BrdNum, 17, 0);
        if (error)
            return;
        end;
        
        % Enable Sequence Frame Rate
        error = calllib('ppcdll', 'WriteReg', BrdNum, 18, 1);
        if (error)
            return;
        end;
    else
        % If the Frame Rate is non-zero then setting the frame period
        % will automatically enable the Sequence hardware.
        period = round(1/FRRate / 16e-9); % 62.5 MHz Clock
        if (period == 0 || period > 2^32-1)
            error = 1016;
            return;
        end;
        error = calllib('ppcdll', 'WriteReg', BrdNum, 17, period);
    end;
end