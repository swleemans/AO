% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Sets the Orientation of the DM.
% Options include
%   0) "Normal"
%   1) "FlipX"
%   2) "FlipY"
%   3) "FlipXY"
%   4) "Transpose"
%   5) "Transpose, FlipX"
%   6) "Transpose, FlipY"
%   7) "Transpose, FlipXY"
function error = SetDMorientation(BrdNum, HVAType, OrienSelect)

    [error, Mode] = GetCurrentHVAmode(BrdNum);
    if (error) return; end;

    load('BMCHVA_config_v50.mat');
    
    eval(sprintf('isvalid = exist(''%s'');', HVAType));
    
    if (isvalid == 0)
        error = 1001; % HVA Type Unknown
        return
    else
    
        eval(sprintf('Curr_HVA = %s;', HVAType));
        
        if(Curr_HVA.idnum ~= Mode.idnum)
            error = 1020;
            return;
        end;
        
        switch OrienSelect
            case {'Normal'}
                error = WriteHVALUT(BrdNum, Curr_HVA.hva_lut, Curr_HVA.active_map);
                if (error) return; end;
                error = calllib('ppcdll', 'WriteReg', BrdNum, 7, 0);
            case {'FlipX'}
                active_lut = NaN*Curr_HVA.hva_lut;
                active_map = NaN*Curr_HVA.active_map;
                array_size = size(active_lut);
                for r = 1 : array_size(1);
                    for c = 1 : array_size(2);
                        active_lut(r,c) = Curr_HVA.hva_lut(r,array_size(2)-c+1);
                        active_map(r,c) = Curr_HVA.active_map(r,array_size(2)-c+1);
                    end;
                end;
                error = WriteHVALUT(BrdNum, active_lut, active_map);
                if (error) return; end;
                error = calllib('ppcdll', 'WriteReg', BrdNum, 7, 1);
            case {'FlipY'}
                active_lut = NaN*Curr_HVA.hva_lut;
                active_map = NaN*Curr_HVA.active_map;
                array_size = size(active_lut);
                for r = 1 : array_size(1);
                    for c = 1 : array_size(2);
                        active_lut(r,c) = Curr_HVA.hva_lut(array_size(1)-r+1,c);
                        active_map(r,c) = Curr_HVA.active_map(array_size(1)-r+1,c);
                    end;
                end;
                error = WriteHVALUT(BrdNum, active_lut, active_map);
                if (error) return; end;
                error = calllib('ppcdll', 'WriteReg', BrdNum, 7, 2);
            case {'FlipXY'}
                active_lut = NaN*Curr_HVA.hva_lut;
                active_map = NaN*Curr_HVA.active_map;
                array_size = size(active_lut);
                for r = 1 : array_size(1);
                    for c = 1 : array_size(2);
                        active_lut(r,c) = Curr_HVA.hva_lut(array_size(1)-r+1,array_size(2)-c+1);
                        active_map(r,c) = Curr_HVA.active_map(array_size(1)-r+1,array_size(2)-c+1);
                    end;
                end;
                error = WriteHVALUT(BrdNum, active_lut, active_map);
                if (error) return; end;
                error = calllib('ppcdll', 'WriteReg', BrdNum, 7, 3);
            case {'Transpose'}
                error = WriteHVALUT(BrdNum, Curr_HVA.hva_lut', Curr_HVA.active_map');
                if (error) return; end;
                error = calllib('ppcdll', 'WriteReg', BrdNum, 7, 4);
            case {'Transpose, FlipX'}
                lut_transpose = Curr_HVA.hva_lut';
                map_transpose = Curr_HVA.active_map';
                active_lut = NaN*Curr_HVA.hva_lut';
                active_map = NaN*Curr_HVA.active_map';
                array_size = size(active_lut);
                for r = 1 : array_size(1);
                    for c = 1 : array_size(2);
                        active_lut(r,c) = lut_transpose(r,array_size(2)-c+1);
                        active_map(r,c) = map_transpose(r,array_size(2)-c+1);
                    end;
                end;
                error = WriteHVALUT(BrdNum, active_lut, active_map);
                if (error) return; end;
                error = calllib('ppcdll', 'WriteReg', BrdNum, 7, 5);
            case {'Transpose, FlipY'}
                lut_transpose = Curr_HVA.hva_lut';
                map_transpose = Curr_HVA.active_map';
                active_lut = NaN*Curr_HVA.hva_lut';
                active_map = NaN*Curr_HVA.active_map';
                array_size = size(active_lut);
                for r = 1 : array_size(1);
                    for c = 1 : array_size(2);
                        active_lut(r,c) = lut_transpose(array_size(2)-r+1,c);
                        active_map(r,c) = map_transpose(array_size(2)-r+1,c);
                    end;
                end;
                error = WriteHVALUT(BrdNum, active_lut, active_map);
                if (error) return; end;
                error = calllib('ppcdll', 'WriteReg', BrdNum, 7, 6);
            case {'Transpose, FlipXY'}
                lut_transpose = Curr_HVA.hva_lut';
                map_transpose = Curr_HVA.active_map';
                active_lut = NaN*Curr_HVA.hva_lut;
                active_map = NaN*Curr_HVA.active_map;
                array_size = size(active_lut);
                for r = 1 : array_size(1);
                    for c = 1 : array_size(2);
                        active_lut(r,c) = lut_transpose(array_size(1)-r+1,array_size(2)-c+1);
                        active_map(r,c) = map_transpose(array_size(1)-r+1,array_size(2)-c+1);
                    end;
                end;
                error = WriteHVALUT(BrdNum, active_lut, active_map);
                if (error) return; end;
                error = calllib('ppcdll', 'WriteReg', BrdNum, 7, 7);
            otherwise
                error = 1002;
    end;

end