function [ key, time ] = keyWatch( stopTime )
% KEYWATCH  Uses KbCheck to watch keyboard for specified amount of time
%           (between screen flips in experiment).
%           Returns whether 'j' or 'k' was pressed and time of key press.
%
% Lily Solomon-Harris, January 2015

% start timing
tic;

while 1
    elapsedTime = toc;
    if elapsedTime>stopTime
        key = '0';
        time = 0;
        break
    end

    [down,timedown,code] = KbCheck;
    if down
        press = KbName(code);
        if iscell(press)
            press = press{1};
        end

        if strcmp(press,'1') || strcmp(press,'1!')
            key = '1';
            time = timedown;
            while elapsedTime < stopTime
              elapsedTime = toc;
            end
            break
        elseif strcmp(press,'2') || strcmp(press,'2@')
            key = '2';
            time = timedown;
            while elapsedTime < stopTime
              elapsedTime = toc;
            end
            break
        elseif strcmp(press, 'q')
            key = press;
            time = 0;
            break
        else
            fprintf('%s', press);
        end

    end
end
