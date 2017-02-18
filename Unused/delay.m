function [d] = delay(seconds)
% function that pauses the experiment
    
    tic;
    while toc < seconds
        d = toc;
    end
end