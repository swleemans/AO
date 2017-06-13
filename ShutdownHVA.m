% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Releases the DLL
function [ error ] = ShutdownHVA()

    if (libisloaded('ppcdll'))
        unloadlibrary ppcdll;
    end;
    error = 0;
end