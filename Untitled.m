rootPath = pwd;
rootPath = strcat(rootPath, '/');
rightPath = strcat(rootPath, 'RUNEXP.m');
assert( (exist(rightPath, 'file') == 2), 'Early Error: you are in the wrong directory' );
fs = 8000;    
%  
% 
% T = .5; % 2 seconds duration
% 
% t = 0:(1/fs):T;
% 
%  
% 
% f = 10;
% 
% a = 0.5;
% 
% y = 10000*cos(1*pi*f*t)+ 10000*sin(1*pi*f*t);
% 
% 
% sound(y, fs);

% testing = 'discharge.wav';
% [y, freq] = audioread(testing);
% wavedata = y';
% nrchannels = size(wavedata,1);
% InitializePsychSound(1);
% pahandle = PsychPortAudio('Open', [], [], 1, freq, nrchannels);
% PsychPortAudio('Volume', pahandle, 1)
% PsychPortAudio('FillBuffer', pahandle, wavedata)
% t1 = PsychPortAudio('Start', pahandle, 1, 0, 1);
stimCompleted = ;
fidCompleted = fopen(stimCompleted,'r');
for i = 1:(num-1)
    line = fgetl(fidCompleted)
end