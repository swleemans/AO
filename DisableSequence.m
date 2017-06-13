% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Disables the Sequence Hardware
function error = DisableSequence(BrdNum)

    % Disables Sequence Frame Rate
    error = calllib('ppcdll', 'WriteReg', BrdNum, 17, 0);
    if (error)
        return;
    end;

        % Disables Sequence and Pulses State Machine Reset
    error = calllib('ppcdll', 'WriteReg', BrdNum, 18, 2^31);
 
end