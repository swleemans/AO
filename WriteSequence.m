% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Writes the Sequence to Internal Memory.
% The sequence input is NxNxM
% Maximum Sequence length is 4096.
% Sequence values must range between 0 and 65535.
% Delay is in seconds (maximum delay is 0.25 sec)
function error = WriteSequence(BrdNum, sequenceNxNxM, delay)

    dimensions = size(sequenceNxNxM);
mask = ones(dimensions(1),dimensions(2));
     seqlength = sum(mask(:))*dimensions(3);
%     if (seqlength > 4096)
%         error = 1014;
%         return;
%     end;
    
    % Check Sequence Size vs mask size
%     if (~isequal([dimensions(1) dimensions(2)] , size(mask)))
%         error = 1014;
%         return;
%     end;
    
    % Check HVA Status
    [error, Mode] = GetCurrentHVAmode(BrdNum);
    if (error) return; end;    
    
    % Check Array size versus CameraLink limits.
    if (Mode.use_camlink == 1 && dimensions(1)*dimensions(2) > Mode.size)
        error = 1014;
        return;
    end;
    
    % Check Array size versus S-driver limits.
    if (Mode.use_fiber == 1 && Mode.fiber_mode == 0 && dimensions(1)*dimensions(2) > Mode.size)
        error = 1014;
        return;
    end;
    
    % Check Array size versus Kilo limits.
    if (Mode.use_fiber == 1 && Mode.fiber_mode == 1 && dimensions(1)*dimensions(2) > Mode.size)
        error = 1014;
        return;
    end;
    
    if (max(sequenceNxNxM(:)) > 65535)
        error = 1013;
        return;
    end;
    if (min(sequenceNxNxM(:)) < 0)
        error = 1013;
        return;
    end;
    
    if (delay < 0 || delay > 0.25)
        error = 1015;
        return;
    end;
    
    if (delay ~= 0)
        error = calllib('ppcdll', 'WriteReg', BrdNum, 20, round(delay/16e-9));
        if (error) return; end;
    else
        error = calllib('ppcdll', 'WriteReg', BrdNum, 20, 0);
        if (error) return; end;        
    end;
    
    % Create the Sequence
    sequence_arrayU32 = NaN*ones(seqlength,1);
    seqnum = 1;
    for n = 1 : dimensions(3)
        sequenceNxN = round(sequenceNxNxM(:,:,n));
        actnum = 0;
        for r = 1 : dimensions(1)
            for c = 1 : dimensions(2)
%                 if (mask(r,c) == 1)
                    sequence_arrayU32(seqnum) = actnum*2^16 + sequenceNxN(r,c);
                    seqnum = seqnum + 1;
%                 end;
                actnum = actnum + 1;
            end;
        end;
        % Write End of Frame
        sequence_arrayU32(seqnum-1) = sequence_arrayU32(seqnum-1) + 2^28;
    end;
    % Write End of Sequence
    sequence_arrayU32(seqnum-1) = sequence_arrayU32(seqnum-1) + 2^29;

    % Reset Address
    error = calllib('ppcdll', 'WriteReg', BrdNum, 19, hex2dec('80000000'));
    if (error) return; end;
    
    pv = libpointer('uint32Ptr', sequence_arrayU32);
    error = calllib('ppcdll', 'WriteMem', BrdNum, 19, 0, length(sequence_arrayU32), pv);
    if (error) return; end;
    
    % Reset Address
    error = calllib('ppcdll', 'WriteReg', BrdNum, 19, hex2dec('80000000'));
    
end