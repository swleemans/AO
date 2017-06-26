function [I] = transferFun(xseg,yseg,piston,mask)
% black box: 
%  mirror config goes in, multiplied by random mask,
% output=intensity
A=((abs(xseg).*mask).^2+(abs(yseg).*mask).^2)+1e-5;
T=abs(piston).*mask;
I=(10^-6/(A*transpose(T)));
return
end

