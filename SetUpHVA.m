% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Loads the DLL and configures the Board for any DM/HVA
% configuration in the BMCHVA_config_v50.mat constant.
% HVA LUT must be loaded each time because they share
% the same LUT memory.
function [ error ] = SetUpHVA(BrdNum, HVAType)

    if (~libisloaded('ppcdll'))
        %loadlibrary('ppcdll', 'ppcdll.h');
        loadlibrary('ppcdll', @ppcdllPrototype);
    end;
    
    % Read Hardware Revision
    data = libpointer('uint32Ptr', 0);
    error = calllib('ppcdll', 'ReadReg', BrdNum, 0, data);
	if (error) return; end;
    
    % Only HWREV 0x2000XXXX are supported
    if (bitand(data.value,hex2dec('FFFF0000')) ~= hex2dec('20000000'))
        error = 1000;
        return
    end;

    load('BMCHVA_config_v50.mat');
    
    eval(sprintf('isvalid = exist(''%s'');', HVAType));
    
    if (isvalid == 0)
        error = 1001; % HVA Type Unknown
        return
    else
    
        eval(sprintf('Curr_HVA = %s;', HVAType));
        
        hva_length = Curr_HVA.size(1) * Curr_HVA.size(2);
        
        hva_u32 = hva_length*2^16 + Curr_HVA.burst_mode*2^8 + Curr_HVA.fiber_mode*2^7 + Curr_HVA.use_fiber*2^6 + ...
            Curr_HVA.use_camlink*2^5 + Curr_HVA.idnum;
        
        error = calllib('ppcdll', 'WriteReg', BrdNum, 1, hva_u32);
        if (error) return; end;
        
        % Load the correct Default LUT for the HVA
        error = WriteHVALUT(BrdNum, Curr_HVA.hva_lut, Curr_HVA.active_map);
        if (error) return; end;
        
        % Set the DM Orientation to Normal
        error = calllib('ppcdll', 'WriteReg', BrdNum, 7, 0);
                
        if (Curr_HVA.use_fiber == 1 && Curr_HVA.fiber_mode == 0)
            % Enable All DACs is using S-Driver
            for n = 1 : 1024
                actnum = 1024+(n-1);%*4;
                % Enable All DACs
                error = calllib('ppcdll', 'WriteReg', BrdNum, 16, 2^31+actnum*2^16+hex2dec('3C'));
                if (error) return; end;
                
                % Write NOP    
                error = calllib('ppcdll', 'WriteReg', BrdNum, 16, 2^31+2^30+actnum*2^16);
                if (error) return; end;
            end;
        end;
    end;
end