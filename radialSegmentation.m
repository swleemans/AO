
% Simon W. Leemans
% May 2017
%
% Make sure the path includes the BMC driver software
%
clear all
addpath('C:\Program Files\BostonMicromachines\BostonMicro\Matlab\v5.2');
addpath('C:\Program Files\BostonMicromachines\Winx64\x64');
addpath('C:\Program Files\BostonMicromachines\BostonMicro');
% Load lookup table data
load('Lookup_Table.mat');
load('seg_r_theta_xy.mat');
% Specify PCIe Board number for XCL driver (usually 1)
BrdNum = 1;

% Setup driver: All errors should return 0
error_setup = SetUpHVA(BrdNum, HVA);
% error_clear = ClearHVA(1);

% Initialize variables
DM_name = '27BW07_50';  % DM Name
Numsegs = 37;		% Number of segments
maxtilt= 0.052; %radians
% NOTE: Piston values are defined with respect to a datum on the uncontrolled segments surrounding the active array,
%with the positive z axis defined as an outward surface normal from the mirror surface.
% All nonzero actuation commands move the segment in the negative z direction.
%The usable piston range is comprised of all negative values, ranging from -0.1�m to -3.1�m.

rshell=[0.1 0.75 1.4 2];
segBool=[];
%Create matrix with all segments to be turned away from center. Selected by
%dist from center (seg 19)
for i=1:4
    segBool(:,i)=indexRthetaXY(:,2)>rshell(i);
end
xtilts=[];
ytilts=[];
kx2=[];
ky2=[];
address = [];
xseg=zeros(4,37);
yseg=zeros(4,37);
for i =1:3
    % increase number of active segments with increasing i
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    i
    for seg = 1:37
        %%
        address = [seg * 3 - 2, seg * 3 - 1, seg * 3];
        %turn out segments
        if segBool(seg,i)==1
            %seg
%           ytilts=0
%           xtilts=0
            xtilts = indexRthetaXY(seg,4)*maxtilt;
            ytilts = -indexRthetaXY(seg,5)*maxtilt;
        end
        % Inner segments level
        if segBool(seg,i) == 0
            xtilts = 0;
            ytilts = 0;
        end
                
        % Lookup closest tilt indices in table
        % (Note: could interpolate between points if desired)

        [~,kx2] = min(abs(x_tilt_range - xtilts));
        [~,ky2] = min(abs(y_tilt_range - ytilts));
        
        while isnan(piston_range_min_lookup(kx2,ky2))
            if kx2>101
                kx2 = kx2-1;
            else kx2 =kx2+1;
            end
            if ky2<101
                ky2 = ky2+1;
            else ky2= ky2-1;
            end
        end
        xseg(i,seg)= x_tilt_range(kx2);
        yseg(i,seg)= y_tilt_range(ky2);
        
        pmin = piston_range_min_lookup(kx2,ky2);
        pmax = piston_range_max_lookup(kx2,ky2);
        % Set piston request (-0.1um to -3.1um)
        pistons = pmin;
        
        % Lookup closest piston index in table
        [~,kp2] = min(abs(piston_range - pistons));
        
        % Use lookup table to find required actuator commands 
        %if get_commands==0: assume its a copout?
        cmd(1) = get_commands(kx2,ky2,kp2,1);
        cmd(2) = get_commands(kx2,ky2,kp2,2);
        cmd(3) = get_commands(kx2,ky2,kp2,3);

        % Put actuator commands on appropriate actuators
        for j = 1:3
            val = double(get_commands(kx2,ky2,kp2,j));
            addr = address(j);
            PokeDM(BrdNum,addr,val);
        end
        
    end
end