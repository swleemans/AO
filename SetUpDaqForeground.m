clear all
s=daq.createSession('mcc');
ch=addAnalogInputChannel(s,'Board0',[0],'Voltage');
s.DurationInSeconds = 0.10;
data = startForeground(s);
plot (data)