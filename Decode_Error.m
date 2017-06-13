% Copyright 2011-2014 - Pipeline Processing/Nutronics, Inc.
% info@pipelineprocessing.com
% Decodes Error number into string for user.
function [ err_string ] = Decode_Error(code)

    switch code
        case {0}
            err_string = 'No Error';
        case {12}
            err_string = 'Board not found - Range = 1 to N';
        case {1000}
            err_string = 'This board uses the same driver, but is not a BMM HVA PCIe Board';
        case {1001}
            err_string = 'Unknown HVA - Load BMCHVA_config_v50.mat to see supported HVA/DMs';
        case {1002}
            err_string = 'Invalid Orientation (Normal, FlipX, FlipY, FlipXY and Transpose verisions allowed)';
        case {1003}
            err_string = 'Unknown DM Orientation - Hardware Error, Contact Vendor';
        case {1004}
            err_string = 'Invalid Framed LUT (Must be 1xN and not contain any numbers larger than the DM Size';
        case {1005}
            err_string = 'Did not find EOF in Framed LUT Table';
        case {1006}
            err_string = 'Invalid HVA LUT. 0-255 for CameraLink, 0-1023 for S-Driver, 0-4095 for KILO.';
        case {1007}
            err_string = 'ActNum invalid for HVA Type (1 to NxN)';
        case {1008}
            err_string = 'Invalid Dither Gain array.  (Must be 1D)';
        case {1009}
            err_string = 'Invalid Dither Gain.  Values range from 0 to 65535.';
        case {1010}
            err_string = 'Maximum Dither waveform length is 2048';
        case {1011}
            err_string = 'Dither waveform range is 0 to 1.0';
        case {1012}
            err_string = 'Invalid Dither Frame Rate. (Must be Positive)';    
        case {1013}
            err_string = 'Sequence Length is invalid. (Must be positive and <= 4096))';
        case {1014}
            err_string = 'Sequence Parameter is out of range.';
        case {1015}
            err_string = 'Sequence Delay must be positive and < 0.25 seconds';
        case {1016}
            err_string = 'Invalid Sequence Frame Rate. (Must be Positive)';
        case {1017}
            err_string = 'TTL Pulse Width out of Range, Between 0 and 700 usecs';
        case {1018}
            err_string = 'TTL Pulse DAC chan out of range (0-1023)';
        case {1019}
            err_string = 'TTL Pulse DAC Command out of range (0-65535)';
        case {1020}
            err_string = 'Not in Correct HVA Mode';
        otherwise
            err_string = sprintf('Unknown Error = %d', code);
    end;
end