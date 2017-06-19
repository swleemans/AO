% Initialize the variables, load lookup tables used for mirror control
addpath('C:\Program Files\BostonMicromachines\BostonMicro\Matlab\v5.2');
addpath('C:\Program Files\BostonMicromachines\Winx64\x64');
addpath('C:\Program Files\BostonMicromachines\BostonMicro');
addpath(genpath('BostonMicro v5.2'))
% Load lookup table data
load('Lookup_Table.mat');
load('indexRthetaUVXY.mat')
% Specify PCIe Board number for XCL driver (usually 1)
BrdNum = 1;

HVA='XCL 111';


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
    segBool(:,i)=indexRthetaUVXY(:,2)>rshell(i);
end
xtilts=[];
ytilts=[];
kx2=[];
ky2=[];
address = [];
xseg=zeros(4,37);
yseg=zeros(4,37);


