% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Reads the Orientation of the DM.
% Options include
%   0) "Normal"
%   1) "FlipX"
%   2) "FlipY"
%   3) "FlipXY"
%   4) "Transpose"
%   5) "Transpose, FlipX"
%   6) "Transpose, FlipY"
%   7) "Transpose, FlipXY"
function [error Orien] = ReadDMorientation(BrdNum)
    % Read Orientation
    data = libpointer('uint32Ptr', 0);
    error = calllib('ppcdll', 'ReadReg', BrdNum, 7, data);
	if (error)
        return;
    end;
    
    switch data.value
        case {0}
            Orien = 'Normal';
        case {1}
            Orien = 'FlipX';
        case {2}
            Orien = 'FlipY';
        case {3}
            Orien = 'FlipXY';
        case {4}
            Orien = 'Transpose';
        case {5}
            Orien = 'Transpose, FlipX';
        case {6}
            Orien = 'Transpose, FlipY';
        case {7}
            Orien = 'Transpose, FlipXY';
        otherwise
            Orien = 'Unknown Orientation - Hardware Failure Contact Vendor';
            error = 1003;
    end;
end