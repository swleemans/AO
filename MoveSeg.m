function MoveSeg(Seg,xtilt,ytilt)
%Move segment to given piston,tip,tilt Summary of this function goes here
load('Lookup_Table.mat');
load('indexRthetaUVXY.mat')
BrdNum = 1;
HVA='XCL 111';
seg = Seg;
        %%
        address = [seg * 3 - 2, seg * 3 - 1, seg * 3];
        % Lookup closest tilt indices in table
        % (Note: could interpolate between points if desired)

        [~,kx2] = min(abs(x_tilt_range - xtilt));
        [~,ky2] = min(abs(y_tilt_range - ytilt));
        %Find allowable combinations of piston near desired tip,tilt
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
        xseg(seg)= x_tilt_range(kx2);
        yseg(seg)= y_tilt_range(ky2);
        
        pmin = piston_range_min_lookup(kx2,ky2);
        pmax = piston_range_max_lookup(kx2,ky2);
        prompt=strcat('Enter value for piston. Min = ',num2str(pmin), ', Max = ', num2str(pmax));
       
        piston=input(prompt);
        
        
        % Lookup closest piston index in table
        [~,kp2] = min(abs(piston_range - piston));
        
        % Use lookup table to find required actuator commands 
        cmd(1) = get_commands(kx2,ky2,kp2,1);
        cmd(2) = get_commands(kx2,ky2,kp2,2);
        cmd(3) = get_commands(kx2,ky2,kp2,3);

        % Put actuator commands on appropriate actuators
        for j = 1:3
            val = double(get_commands(kx2,ky2,kp2,j));
            addr = address(j);
            PokeDM(BrdNum,addr,val);
        end
        
    figure(i)
   quiver(indexRthetaUVXY(:,6),indexRthetaUVXY(:,7),transpose(xseg(i,:)),-transpose(yseg(i,:)))
end


