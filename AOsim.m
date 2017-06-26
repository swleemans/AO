load('indexRthetaUVXY.mat');
load('mask.mat');
load('Lookup_Table.mat');
segX=indexRthetaUVXY(:,6); %segment index mapping to x
segY=indexRthetaUVXY(:,7); %segment index mapping to y
ep = 0.1; %Convergence limit
rshell=[0.1 0.75 1.4 2]; % Radial segmentation
Numsegs = 37;		% Number of mirror segments
maxtilt= 0.052; %maximum tilt possible for segments, in radians
segBool=zeros(max(size(indexRthetaUVXY(:,2))),4);
Iflat=zeros(4,1);
%Create matrix with all segments to be turned away from center. Selected by
%dist from center (seg 19)
for i=1:4
    segBool(:,i)=indexRthetaUVXY(:,2)>rshell(i);
end
xtilts=[];
ytilts=[];
kx2=[];
ky2=[];
pistons=zeros(4,37);
delta=piston_range(1)-piston_range(2);
address = [];
xseg=zeros(4,37);
yseg=zeros(4,37);
for i =1:4
    i
    % increase number of active segments with increasing i
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for seg = 1:37
        %%
        address = [seg * 3 - 2, seg * 3 - 1, seg * 3];
        %turn out segments
        if segBool(seg,i)==1
            %seg
            %           ytilts=0
            %           xtilts=0
            xtilts = indexRthetaUVXY(seg,4)*maxtilt;
            ytilts = -indexRthetaUVXY(seg,5)*maxtilt;
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
        
        pistons(i,seg)=piston_range_min_lookup(kx2,ky2);
        
        [~,kp2] = min(abs(piston_range - pistons(i,seg)));
        
        cmd(1) = get_commands(kx2,ky2,kp2,1);
        cmd(2) = get_commands(kx2,ky2,kp2,2);
        cmd(3) = get_commands(kx2,ky2,kp2,3);
        for j = 1:3
            val = double(get_commands(kx2,ky2,kp2,j));
            addr = address(j);
            %PokeDM(BrdNum,addr,val);
        end
    end
    %
    % Record (fake) Intensity given DM configuration
    Iflat(i) = transferFun(xseg(i,:),yseg(i,:),pistons(i,:),mask);
    
    %%
    %Optimize inner radial segment, only changing piston(tip, tilt will come soon)%
    for seg=1:37
        seg
        if segBool(seg,i) == 0 && seg~=19
            jmax=4; % Number of steps for mirror optimization. Determines step size.
            k=[-10 -1 1 10];% Take one big step below center segment, then one small step below, followed by inverse (to determine search direction)
            for j= 1:jmax
                piston= pistons(1,19)+delta*k(j);
                %% get commands to set segment to desired level
                %                 [~,kp2] = min(abs(piston_range - piston));
                %                 cmd(1) = get_commands(kx2,ky2,kp2,1);
                %                 cmd(2) = get_commands(kx2,ky2,kp2,2);
                %                 cmd(3) = get_commands(kx2,ky2,kp2,3);
                %%send command to actuator
                %                 for j = 1:3
                %                     val = double(get_commands(kx2,ky2,kp2,j));
                %                     addr = address(j);
                %                     PokeDM(BrdNum,addr,val); % send commands to driver
                %                 end
                I(j)=transferFun(xseg(i,:),yseg(i,:),piston,mask)
            end
            [~,ind]=max(I(j));
            %while ep>abs(I-Iflat(i)) % move through piston values until converged
            %   jmax=jmax
            % end
        end
    end
end


