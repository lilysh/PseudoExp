function [ key, time ] = keyWatch( stopTime )
% KEYWATCH  Uses KbCheck to watch keyboard for specified amount of time
%           (between screen flips in experiment).
%           Returns whether 'j' or 'k' was pressed and time of key press.
%
% Lily Solomon-Harris, January 2015

% start timing
tic;
time = 0;
down = 0;

while ~down
    elapsedTime = toc;
    if elapsedTime>stopTime
        key = '0'; %timeout, nothing entered
        time = elapsedTime;
        break
    end
    [down,timedown,keyCode] = KbCheck();
    press = KbName(keyCode);
end
escapeKey = KbName('ESCAPE');
realKey = KbName('j');
pseudoKey = KbName('k');
pauseKey = KbName('space');
if down
        time = elapsedTime;
        if iscell(press)
            % fprintf('You mashed some keys, congratulations!\n');
            press = press{1};
        end
        key = press;
        if (strcmp(key,'j')) || (strcmp(key,'k'))
            %real or pseudo response          
        elseif keyCode(pauseKey) 
                key = 'p';
                if pauseAllowed
                   time = -1; 
                end
            elseif keyCode(escapeKey)
                time = -2;
                key = 'q';
            else
               pause(stopTime); % user jumped the gun or bad response
               key = 'X';
        end
end

end