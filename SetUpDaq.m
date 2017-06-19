clear all
s=daq.createSession('mcc');
ch=addAnalogInputChannel(s,'Board0',[0],'Voltage');
s.IsContinuous=1;
lh = addlistener(s,'DataAvailable', @plotData); 
 startBackground(s);
 'Type s.stop to stop listening'
 function plotData(src,event)
% ylim([0 4])
     plot(event.TimeStamps, event.Data)
 end
