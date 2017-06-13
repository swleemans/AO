% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Retrieves HVA Information for a given HVA/DM.
function [ error, Info ] = RetrieveHVAInfo(HVAType)

    error = 0;
    Info = [];    

    load('BMCHVA_config_v50.mat');
    
    eval(sprintf('isvalid = exist(''%s'');', HVAType));
    
    if (isvalid == 0)
        error = 1001; % HVA Type Unknown
    else
        eval(sprintf('Info = %s;', HVAType));
    end;
end