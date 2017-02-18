function pt = pseudoTrial(stimObject)
         pt = struct ('pseudoStim','',...   % stimulus object
                      'responseKey','',...  % key pressed (char)
                      'responseType','',... % real or pseudo
                      'wasCorrect',0,...    % whether key was correct (boolean)
                      'responseTime',0,...  % time til response (secs)
                      'onsetTime',0,...     % time trial started (secs)
                      'stimDur',0,...       % length of stimulus (secs)
                      'maskDur',0,...       % length of mask (secs)
                      'fixDur',0 ...        % length of fixation (secs)
                         );
         pt.pseudoStim = stimObject;
end
