function [ key, time ] = keyWatch( stopTime, correctKey, right, wrong )
% KEYWATCH  Uses KbCheck to watch keyboard for specified amount of time
%           (between screen flips in experiment).
%           Returns which key was pressed and time of key press.
%
% Lily Solomon-Harris, January 2015

% start timing
tic;

if nargin> 3
  practiceMode = 1;
else
  practiceMode = 0;
end

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
            if practiceMode
              %If in practice give feedback on the reponse
              if strcmp(correctKey, key)
                  PsychPortAudio('Start', right, 1, 0, 1);
              else
                  PsychPortAudio('Start', wrong, 1, 0, 1);
              end
            end
            while elapsedTime < stopTime
              elapsedTime = toc;
            end
            break
        elseif strcmp(press,'2') || strcmp(press,'2@')
            key = '2';
            time = timedown;
            if practiceMode
              %If in practice give feedback on the reponse
              if strcmp(correctKey, key)
                  PsychPortAudio('Start', right, 1, 0, 1);
              else
                  PsychPortAudio('Start', wrong, 1, 0, 1);
              end
            end
            while elapsedTime < stopTime
              elapsedTime = toc;
            end
            break
        elseif strcmp(press, 'q')
            fprintf('quitting\n')
            key = press;
            time = 0;
            break
        else
            fprintf('%s', press);
        end
    end
end
