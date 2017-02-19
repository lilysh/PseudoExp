        % take arguements for setting up experiment
        if nargin<1
            expmode = input('TMS ON/OFF [1=ON; 0=OFF]: ');
        end
        
        if ~(expmode == 1 || expmode == 0)
            msg = 'Invalid entry';
            error(msg);  %% why is the error function underlined here like it's a variable??
        end

        if nargin<2
            subcode = input('Subject code: ', 's');
        end
        subcode = upper(subcode);

        if nargin<3
            session = input('Session [1, 2, or 3]: ');
        end
        if ~(session == 3 || session == 2 || session == 1)
            msg = 'Invalid entry';
            error(msg);
        end

        if nargin<4
            phase = input('Phase [practice, study, or test]: ', 's');
        end
        switch phase
            case {'practice','study','test','PRACTICE','STUDY','TEST'}
                phase = lower(phase);
            otherwise
                error('Unexpected phase');
        end

        if nargin<5
            if strcmp(phase, 'practice')
                block = input('Block [word, face, or object]: ', 's');
            else
                block = input('Block [word1, word2, face, or object]: ', 's');
            end
        end
        switch block
            case {'word','word1','word2','face','object','WORD','WORD1','WORD2','FACE','OBJECT'}
                 block = lower(block);
            otherwise
                error('Unexpected block');
        end

        if nargin<6
            button = input('Button for real stimuli [one or two]: ', 's');
        end
        
        if ~strcmp(button, 'one') || strcmp(button, 'two')
            error('Unexpected button');
        end

        if nargin<7
            resume = input('Resume? [1 = yes, 0 = no]: ');
        end
        
        if ~(resume == 0 || resume == 1)
            msg = 'Invalid entry';
            error(msg);
        end