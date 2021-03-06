function [numTrials, itrialiS] = setParams(phase, block)

    % set number of stimuli, number of trials, and intertrial intervals  
    if strcmp(phase, 'Practice')
        numTrials = 10;                   % number of trials in practice blocks
        itrialiS = 3.2 + 0.4*rand() - 0.0168 - 0.0166; % intertrial interval (seconds)
    elseif strcmp(phase, 'Study')
        numTrials = 160;                  % number of trials in study blocks
        itrialiS = 3.2 + 0.4*rand() - 0.0168;  % intertrial interval (seconds)
    elseif strcmp(phase, 'Test')
        itrialiS = 2.0 - 0.0168;          % intertrial interval (seconds)

        switch block
            case {'Word1'}
                numTrials = 120;  % number of trials in test word blocks
            case {'Word2'}
                numTrials = 120;  % number of trials in test word blocks                  
            case {'Face'}
                numTrials = 160;  % number of trials in test face/object blocks   
            case {'Object'}
                numTrials = 160;  % number of trials in test face/object blocks  
            otherwise
                error('Wrong block');
        end
    else
        error('Unexpected phase type.');
    end 

end