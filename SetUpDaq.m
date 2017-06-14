clear all
s=daq.createSession('mcc');
<<<<<<< Updated upstream
ch=addAnalogInputChannel(s,'Board0',[0],'Voltage');
=======
ch=addAnalogInputChannel(s,'Board0',[1 2],'Voltage');
>>>>>>> Stashed changes
s.IsContinuous=1;
lh = addlistener(s,'DataAvailable', @plotData); 
 startBackground(s);
 'Type s.stop to stop listening'
 function plotData(src,event)
     plot(event.TimeStamps, event.Data)
 end
