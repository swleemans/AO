% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Downloads the HVA LUT for the active HVA.
% This LUT maps addresses to actual DAC channels
% on the HVA. Use SetDMorientation to flip the mirror around.
% If Mask(m,n) is zero, then that actuator is not valid and never
% written to the HVA.
function error = WriteHVALUT(BrdNum, Array, Mask)

%     if (~isequal(size(Array),size(Mask)))
%         error = 1006;
%         return;
%     end;
    
%     if (max(Mask(:)) > 1 || min(Mask(:)) < 0)
%         error = 1006;
%         return;
%     end;
    
    % Check HVA Status
    [error, Mode] = GetCurrentHVAmode(BrdNum);
    if (error) return; end;
        
    if (Mode.use_camlink == 1)
        % Array is zero based and must be less than 256
        if (max(Array(:)) > 255 || min(Array(:)) < 0)
            error = 1006;
            return;
        end;
    elseif (Mode.use_fiber == 1)
        if (Mode.fiber_mode == 0)
            % Array is zero based and must be less than 1024
            if (max(Array(:)) > 1023 || min(Array(:)) < 0)
                error = 1006;
                return;
            end;
        else
            % Array is zero based and must be less than 4096
            if (max(Array(:)) > 4095 || min(Array(:)) < 0)
                error = 1006;
                return;
            end;
        end;
    end;
    
    array_size = size(Array);
    if (array_size(1)*array_size(2) ~= Mode.size)
        error = 1006;
        return;
    end;    
    
    array_u32 = reshape(Array',Mode.size,1);
    mask_u32 = reshape(Mask',Mode.size,1);
    
    % Reset Address
    error = calllib('ppcdll', 'WriteReg', BrdNum, 6, hex2dec('80000000'));
    if (error) return; end;
    
    for n = 1 : Mode.size
        if (mask_u32(n) == 0)
            error = calllib('ppcdll', 'WriteReg', BrdNum, 6, 2^16);
        else
            error = calllib('ppcdll', 'WriteReg', BrdNum, 6, array_u32(n));
        end;
        if (error) return; end;
    end;
    
    if (Mode.size < 2^12)
        for n = Mode.size+1 : 2^12
            error = calllib('ppcdll', 'WriteReg', BrdNum, 6, 2^16);
            if (error) return; end;
        end;
    end;
    
    % Reset Address
    error = calllib('ppcdll', 'WriteReg', BrdNum, 6, hex2dec('80000000'));
    
end