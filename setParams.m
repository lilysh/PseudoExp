function [numTrials, itrialiS] = setParams(phase, block)

    % set number of stimuli, number of trials, and intertrial intervals  
    if strcmp(phase, 'Practice')
        numTrials = 10;           % number of trials in practise blocks
        itrialiS = 3.4 - 0.0168 - 0.0166;    % intertrial interval (seconds)
    elseif strcmp(phase, 'Study')
        numTrials = 160;          % number of trials in study phase blocks
        itrialiS = 3.4 - 0.0168;    % intertrial interval (seconds)
    elseif strcmp(phase, 'Test')
        itrialiS = 2.0 - 0.0168;    % intertrial interval (seconds)

        switch block
            case {'Word1'}
                numTrials = 120;  % number of trials in test phase word blocks
            case {'Word2'}
                numTrials = 120;  % number of trials in test phase word blocks                  
            case {'Face'}
                numTrials = 160;  % number of trials in test phase face & object blocks   
            case {'Object'}
                numTrials = 160;  % number of trials in test phase face & object blocks  
            otherwise
                error('Wrong block');
        end
    else
        error('Unexpected phase type.');
    end 

end