function pseudoExp( expmode, subcode, sex, age, session, phase, block, button, resume)
    try % try catch block to make sure everything closes properly on a crash

        %just setting up the rootpath and clearing the workspace
        %clear();
        rootPath = pwd;
        fprintf(rootPath);
        rootPath = strcat(rootPath, '/');
        rightPath = strcat(rootPath, 'RUNEXP.m');
        assert( (exist(rightPath, 'file') == 2), 'Early Error: you are in the wrong directory' );



        %Takes arguements for setting up the experiment
        if nargin<1
            expmode = input('TMS ON/OFF [1=ON; 0=OFF]: ');
        end

        if ~(expmode == 1 || expmode == 0)
            error(msg);
        end

        if nargin<2
            subcode = input('Subject code: ', 's');
        end
        subcode = upper(subcode);


        if nargin<3
            sex = input('Subject sex: ', 's');
            if ~(strcmp(sex,'m')) && ~(strcmp(sex,'f'))
                error('Invalid entry');
            end
        end

        if nargin<4
            age = input('Subject age: ', 's');
        end

        if nargin<5
            session = input('Session [1, 2, or 3]: ');
        end
        if ~(session == 3 || session == 2 || session == 1)
            msg = 'Invalid entry';
            error(msg);
        end

        if nargin<6
            phase = input('Phase [practice, study, or test]: ', 's');
        end
        switch phase
            case {'practice','study','test','PRACTICE','STUDY','TEST'}
                phase = lower(phase);
            otherwise
                error('Unexpected subject code.');
        end

        if nargin<7
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
                error('Unexpected block code.');
        end

        if nargin<8
            button = input('Button for real stimuli [left or right]: ', 's');
        end

        if nargin<9
            resume = input('Resume? [1 = yes, 0 = no]: ');
        end

            % set keys for real and pseudo stimuli
        if strcmp(button, 'left')
            realButton = '1';      % USE 1 & 2 FOR MRI
            pseudoButton = '2';
        elseif strcmp(button, 'right')
            realButton = '2';
            pseudoButton = '1';
        else
            error('Unexpected button type.');
        end

        isTest = strcmp(phase,'test');
        if strcmp(block, 'word') || strcmp(block,'word1') || strcmp(block,'word2')
            isWord = 1;
        end

        %Set up the sound files for correct/incorrect responses and the
        %discharge sound

        %correct sound
        %read the file containing the sound
        sound = 'right.wav';
        [y, freq] = audioread(sound);

        %Transpose and obtain the number of channels for the sound
        wavedata = y';
        nrchannels = size(wavedata,1);

        %Intialize sound drivers and and to buffer
        InitializePsychSound(1);
        right = PsychPortAudio('Open', [], [], 1, freq, nrchannels);
        PsychPortAudio('FillBuffer', right, wavedata);

        %incorrect sound
        sound = 'wrong.wav';
        [y, freq] = audioread(sound);
        wavedata = y';
        nrchannels = size(wavedata,1);
        wrong = PsychPortAudio('Open', [], [], 1, freq, nrchannels);
        PsychPortAudio('FillBuffer', wrong, wavedata);

        %discharge sound
        sound = 'discharge.wav';
        [y, freq] = audioread(sound);
        wavedata = y';
        nrchannels = size(wavedata,1);
        discharge = PsychPortAudio('Open', [], [], 1, freq, nrchannels);
        PsychPortAudio('FillBuffer', discharge, wavedata);

        %Intializing settins for the experiment
        optimalS = 0.0168;
        stimdurS = 0.300-optimalS;   % stimulus duration (seconds)
        maskdurS = 0.200-optimalS;   % noise mask duration (seconds)
        bglumRGB = 255;            % background luminance (RGB)
        fixRGB = 0;                % fixation colour (RGB)
        lineLength = 28;           % fixation line length (pixels)
        lineWidth = 3;             % fixation line width (pixels)
        responseTime = 0;
        close all;
        clear screen;
        sca;

        Screen('Preference', 'SkipSyncTests', 2);
        Screen('Preference', 'SuppressAllWarnings', 1);
        % initialize DataPixx in experimental mode
        if expmode
            PsychDataPixx('Open');
            isReady = Datapixx('IsReady');
            if isReady ~= 1
                error('Datapixx not ready\n');
            end
            Datapixx('StopAllSchedules');
            Datapixx('RegWrRd');
            Datapixx('SetDoutValues', 0);
            Datapixx('RegWrRd');
        end

        % use TMS in study phase of experimental mode
        if strcmp(phase, 'study') && expmode
            useTMS = 1;
        else
            useTMS = 0;
        end
        %Set args in a standard format
        [phase, block, sex] = checkArgs(phase, block, sex);
        %Set fixation duration and number of trials
        [numTrials, itrialiS] = setParams(phase, block);
        isTest = strcmpi(phase, 'test');

            % get screen numbers for all screens connected to computer
        screens = Screen('Screens');

        % draw to the external screen when another monitor is connected
        screenNumber = max(screens);

        % call keyboardCheck function to preload mex file
        [~] = KbCheck;
        [~,~,~] = KbWait;

        %Create empty trials to be filled in later
        for i = 1:numTrials  % populate dummy structures
            stim = pseudoStim('');
            thisTrial = pseudoTrial(stim);
            completedTrials(i) = thisTrial;
        end




        %Set the appropriate file paths to get legends and stims as well as
        %record data and back ups
        [stimPath, legPath, wordBlock] = setPaths(block, subcode, session, phase);
        fileName=[ 'Data/' subcode '/SESSION_' int2str(session) '/' upper(block)  '/pseudoexp_' subcode '_' int2str(session) '_' phase '_' block '.log' ];
        %fprintf('filename: %s\n', fileName);
        consistentStims = [ 'Data/' subcode '/SESSION_' int2str(session) '/' upper(block) '/CONSISTENT_STIMS/pseudoexp_' subcode '_' int2str(session) '_' phase '_' block '_consistentStims.txt' ];
        inconsistentStims = [ 'Data/' subcode '/SESSION_' int2str(session) '/' upper(block)  '/CONSISTENT_STIMS/pseudoexp_' subcode '_' int2str(session) '_' phase '_' block '_inconsistentStims.txt' ];
    %     stimOrder = [ 'Data/' subcode '/SESSION_' int2str(session) '/COMPLETED_TRIALS/pseudoexp_' subcode '_' int2str(session) '_' phase '_' block '_stimOrder.txt' ];
        stimCompleted = [ 'Data/' subcode '/SESSION_' int2str(session) '/' upper(block)  '/COMPLETED_TRIALS/pseudoexp_' subcode '_' int2str(session) '_' phase '_' block '_stimCompleted.txt' ];

        %get the date and time to tag back ups
        date = clock;
        date = num2str(date);
        date = date(find(~isspace(date)));

    %     orderBackup = [ 'Data/' subcode '/SESSION_' int2str(session) '/BACKUP/pseudoexp_' subcode '_' int2str(session) '_' phase '_' block '_stimOrder_' date '.txt' ];
        completedBackup = [ 'Data/' subcode '/SESSION_' int2str(session) '/' upper(block)  '/BACKUP/pseudoexp_' subcode '_' int2str(session) '_' phase '_' block '_stimCompleted_' date '.txt' ];
        dataBackup = [ 'Data/' subcode '/SESSION_' int2str(session) '/' upper(block)  '/BACKUP/pseudoexp_' subcode '_' int2str(session) '_' phase '_' block '_' date '.log'];

        %Check to see if it is testphase and if it is get the consistent stims
        %from the study phase
        if isTest
            studyStims = [ 'Data/' subcode '/SESSION_' int2str(session) '/' upper(block)  '/CONSISTENT_STIMS/pseudoexp_' subcode '_' int2str(session) '_Study_' block '_consistentStims.txt' ];
        else
            studyStims = [];
        end

        %Check if we are resuming and set file permission accordingly
        if resume
            %Setting file permissions when resuming
            fid=fopen(fileName, 'a');
            fprintf('fid: %d', fid);
    %         fidOrder = fopen(stimOrder,'r');
            fidCompleted = fopen(stimCompleted,'r');
            copyfile(stimCompleted,completedBackup)
            fidCompletedBackup = fopen(completedBackup,'a');
            fidDataBackup = fopen(dataBackup,'w');

            %Write participant information into the results back up.
            fprintf(fidDataBackup,'SUBJECT\t%s\n', subcode);
            fprintf(fidDataBackup,'SEX\t%s\n', sex);
            fprintf(fidDataBackup,'AGE\t%s\n', age);
            fprintf(fidDataBackup,'TIME\t%s\n', datestr(now));
            fprintf(fidDataBackup,'SESSION\t%d\n', session);
            fprintf(fidDataBackup,'PHASE\t%s\n', phase);
            fprintf(fidDataBackup,'BLOCK\t%s\n', block);
            fprintf(fidDataBackup,'BUTTON\t%s\n', button);

            fprintf(fidDataBackup,'\nTrial\tOnset\tStimDur\tMaskDur\tFixDur\tKeyPress\tResponseType\tRxnTime\tAccuracy\tDispCount\tStimulus\tStimulusType\tStimulusCategory\tFilename\n');
        else
            fprintf('%s\n', dataBackup);
            [fid, err] = fopen(fileName, 'w');
    %         fidOrder = fopen(stimOrder,'w');
            fidCompleted = fopen(stimCompleted,'w');
    %         fidOrderBackup = fopen(orderBackup,'w');
            fidCompletedBackup = fopen(completedBackup,'w');
            fidDataBackup = fopen(dataBackup,'w');

            fprintf(fid,'SUBJECT\t%s\n', subcode);
            fprintf(fid,'SEX\t%s\n', sex);
            fprintf(fid,'AGE\t%s\n', age);
            fprintf(fid,'TIME\t%s\n', datestr(now));
            fprintf(fid,'SESSION\t%d\n', session);
            fprintf(fid,'PHASE\t%s\n', phase);
            fprintf(fid,'BLOCK\t%s\n', block);
            fprintf(fid,'BUTTON\t%s\n', button);
            fprintf(fid,'\nTrial\tOnset\tStimDur\tMaskDur\tFixDur\tKeyPress\tResponseType\tRxnTime\tAccuracy\tDispCount\tStimulus\tStimulusType\tSimulusCategory\tFilename\n');

            fprintf('%s\n', fidDataBackup);
            fprintf(fidDataBackup,'SUBJECT\t%s\n', subcode);
            fprintf(fidDataBackup,'SEX\t%s\n', sex);
            fprintf(fidDataBackup,'AGE\t%s\n', age);
            fprintf(fidDataBackup,'TIME\t%s\n', datestr(now));
            fprintf(fidDataBackup,'SESSION\t%d\n', session);
            fprintf(fidDataBackup,'PHASE\t%s\n', phase);
            fprintf(fidDataBackup,'BLOCK\t%s\n', block);
            fprintf(fidDataBackup,'BUTTON\t%s\n', button);

            fprintf(fidDataBackup,'\nTrial\tOnset\tStimDur\tMaskDur\tFixDur\tKeyPress\tResponseType\tRxnTime\tAccuracy\tDispCount\tStimulus\tStimulusType\tStimulusCategory\tFilename\n');
        end
        % Check if the legend file exists and read it
        metaDataPath = strcat(legPath,'csv');
        assert( (exist(metaDataPath,'file') == 2), 'File %s does not exist', metaDataPath );
        metaData = fopen(metaDataPath,'r');

        %Put the stimulus information into the trials
        for i = 1:numTrials
            % Read the legend line
            thisRecord = fgetl(metaData);

            %create comma delimited input for creating a stimulus
            thisMeta = [block ',' phase ',' thisRecord];
            stim = pseudoStim(thisMeta);

            if stim.isReal == 1         % assign correct key to stimulus object
                   stim.correctKey = realButton;
            else
                   stim.correctKey = pseudoButton;
            end
            stimuli(i) = stim; %#ok<*AGROW>
        end
        fclose(metaData);

        %Set the display counts for the stimuli; starts from the second stimuli
        %and compares to all previous stimuli, it the assigns appropriate
        %display count
        for i = 2:numel(stimuli)
            %boolean for repeat. Set to false by default
            repeat = false;
            for j = 1:(i-1)
                %If stim.ID of current stimuli i matches any previous stimuli
                if strcmp(stimuli(i).stimID,stimuli(j).stimID)
                    %Set repeat true
                    repeat = true;
                end
            end
            %If stimuli has been shown before set stimCount to 2 otherwise set
            %it to 1
            if repeat
                stimuli(i).stimCount = 2;
            else
                stimuli(i).stimCount = 1;
            end
        end

         %If resuming go to correct trial otherwise start from trial 1
         if ~resume
    %         for i = 1:numel(stimuli)
    %             fprintf(fidOrder,'%s\t%s\n',stimuli(i).stimID,int2str(stimuli(i).stimCount));
    %             fprintf(fidOrderBackup,'%s\t%s\n',stimuli(i).stimID,int2str(stimuli(i).stimCount));
    %         end
             num = 1;
         else
    %         getOrder = textscan(fidOrder,'%[^\n\r]');
    %         getOrder = getOrder{:};
    %         for i = 1:numTrials
    %             line = strsplit(getOrder{i},'\t');
    %             nextStim = line{1};
    %             nextDC = line{2};
    %             for j = 1:numel(stimuli)
    %                 if strcmpi(nextStim,stimuli(j).stimID) && strcmpi(nextDC,int2str(stimuli(j).stimCount))
    %                     newOrder(i) = stimuli(j);
    %                 end
    %             end
    %         end
    %         stimuli = newOrder;

             %Read the completed trials file and get the total number of trials
             %completed
             getCompleted = textscan(fidCompleted,'%[^\n\r]');
             getCompleted = getCompleted{:};
             %We need total completed + 1 to get the starting point
             num = numel(getCompleted)+1;
             fclose(fidCompleted);
             %Append trial information to completed trials file
             fidCompleted = fopen(stimCompleted,'a');
         end

        % Here we are preloading the images
        for i = 1:numTrials
            %Get current stimuli
            thisStim = stimuli(i);
            %Set path
            targetPath=strcat(rootPath, stimPath, thisStim.fileName);
            %make sure it is string
            stringie = char(targetPath);
            %load image and store it in an array
            img = imread(stringie);
            stimulusImage{i} = img;
        end

        [winID,winRect] = Screen('OpenWindow',screenNumber,bglumRGB);
        %HideCursor;
        ListenChar(2);
        %fprintf('about to focus window');
        %Screen('MATLABToFront', 0); %focus on matlab command window

        centreX = winRect(3)/2;
        centreY = winRect(4)/2;

        % set text preferences for instruction screen
        Screen('TextFont', winID, 'Arial');
        Screen('TextSize', winID, 30);

        % null the colour lookup table
        gtable = repmat( linspace(0,1,256)', [ 1 3 ] );
        Screen('LoadNormalizedGammaTable',winID,gtable); % DON'T DO THIS IF USING DATAPIXX TO DISPLAY IMAGES

            % display instructions and wait for key press to begin experiment
        if strcmpi(block,'word1') || strcmpi(block,'word2')
            thing = 'word';
        else
            thing = block;
        end
        thing = lower(thing);

        instructions = ['Press ''' realButton ''' for ' thing 's and ''' pseudoButton ''' for non-' thing 's'];
        quickAccurate = 'Answer as quickly and accurately as possible';
        pressAnyKey = 'Press any key to begin the experiment';
        DrawFormattedText(winID, instructions, 'center', centreY-150, 0);
        DrawFormattedText(winID, quickAccurate, 'center', centreY-50, 0);
        DrawFormattedText(winID, pressAnyKey, 'center', centreY+50, 0);
        DrawFormattedText(winID, 'Press ''Q'' to quit', 'center', centreY+150, 0); %quitKeyQ
        Screen('Flip',winID);
        KbStrokeWait;

        keyFound = 0;
        Screen('DrawLine',winID,fixRGB,(centreX-lineLength),centreY,(centreX+lineLength),centreY, lineWidth);
        Screen('DrawLine',winID,fixRGB,centreX,(centreY-lineLength),centreX,(centreY+lineLength), lineWidth);
        realFixStart = Screen('Flip',winID);
        experimentStart = realFixStart;
        stimStart = realFixStart + itrialiS + 0.0166;


        for i = num:numTrials
            %Pick stimulus, create trial and add it to completed trials
            thisStim = stimuli(i);
            thisTrial = pseudoTrial(thisStim);

            %Show Stimuli and as well as get fixation duration and stim start
            %time
            Screen('PutImage', winID, stimulusImage{i});
            realStimStart = Screen('Flip',winID,stimStart);
            realFixDur = realStimStart - realFixStart;

            %Use TMS
            if useTMS
                Datapixx('SetDoutValues', 1); % store trigger value in memory
                Datapixx('RegWrVideoSync');   % make DataPixx send pulse on next flip
                Datapixx('SetDoutValues', 0); % reset trigger value in memory
                Datapixx('RegWrRd');          % send trigger value
            end

            %If no TMS and in study or phase play mock discharge sound on
            %stimulus onset
            if ~expmode && ~strcmpi(phase,'practice')
                PsychPortAudio('Start', discharge, 1, 0, 1);
            end

            %wait 150 ms before looking for key stroke
            delay(.150);
            if strcmpi(phase,'practice')
                [key,keyTime] = keyWatch(stimdurS-0.250, thisTrial.pseudoStim.correctKey, right, wrong);
            else
                [key,keyTime] = keyWatch(stimdurS-0.250);
            end
            % if a key was pressed, don't check for any more this trial
            if keyTime ~=0
                keyFound = 1;
            end

            %Show mask and get duration of stim and mask start time
            maskStart = realStimStart + stimdurS;
            mask=round(255*rand(winRect(4),winRect(3)));
            Screen('PutImage', winID, mask);
            realMaskStart = Screen('Flip',winID,maskStart);

            %If the reponse has been recorded do not check for input
            if ~keyFound
                if strcmpi(phase,'practice')
                    [key,keyTime] = keyWatch(maskdurS, thisTrial.pseudoStim.correctKey, right, wrong);
                else
                    [key,keyTime] = keyWatch(maskdurS);
                end
                if keyTime ~=0
                    keyFound = 1;
                end
            end

                    % display fixation between trials
            fixStart = realMaskStart + maskdurS;
            Screen('FillRect',winID,bglumRGB);
            Screen('DrawLine',winID,fixRGB,(centreX-lineLength),centreY,(centreX+lineLength),centreY, lineWidth);
            Screen('DrawLine',winID,fixRGB,centreX,(centreY-lineLength),centreX,(centreY+lineLength), lineWidth);
            realFixStart = Screen('Flip',winID,fixStart);

            if ~keyFound
                if strcmpi(phase,'practice')
                    [key,keyTime] = keyWatch(itrialiS, thisTrial.pseudoStim.correctKey, right, wrong);
                else
                    [key,keyTime] = keyWatch(itrialiS);
                end
            end

            % get stimulus timing data
            realStimDur = realMaskStart - realStimStart;
            stimStart = realFixStart + itrialiS;
            realMaskDur = realFixStart - realMaskStart;

            if strcmp(key, 'q') % quit if q was pressed
              sca();
              ListenChar(0);
              fprintf('### Block terminated early ###\n\n');
              exit();
            elseif keyTime == 0          % if no response
                responseTime = 0;
                key = '0';
            else                     % else calculate response time
                responseTime = keyTime - realStimStart;
            end

            %Record Onset
            onset = realStimStart-experimentStart;

            %Record trial information
            thisTrial.responseKey = key;
            thisTrial.responseTime = responseTime;
            thisTrial.onsetTime = onset;
            thisTrial.stimDur = realStimDur;
            thisTrial.maskDur = realMaskDur;
            thisTrial.fixDur = realFixDur;
            if strcmp(key,realButton)
                thisTrial.responseType = 'real';
            elseif strcmp(key,pseudoButton)
                thisTrial.responseType = 'pseudo';
            else
                thisTrial.responseType = 'NoResponse';
            end
            completedTrials(i) = thisTrial;

            %Print trial info to console to monitor perfomance during
            %scanning
            fprintf('\nTrial\tOnset\tStimDur\tMaskDur\tFixDur\n');
            fprintf('%d\t%3.2f\t%1.4f\t%1.4f\t%3.4f\n\n',i,thisTrial.onsetTime,thisTrial.stimDur,thisTrial.maskDur,thisTrial.fixDur);
            fprintf('Trial:\t%d\nResponseType:\t%s\nRxnTime:\t%1.4f\nAccuracy:\t%d\nDispCount:\t%d\nStimulus:\t%s\nStimulusType:\t%s\nStimulusCategory:\t%s\n\n',i,thisTrial.responseType,thisTrial.responseTime,correct,char(thisTrial.pseudoStim.stimCount),thisTrial.pseudoStim.stimID,thisTrial.pseudoStim.stimType, thisTrial.pseudoStim.wordRelation);

            %Print results and backup
            fprintf(fid,'%d\t%3.2f\t%1.4f\t%1.4f\t%3.4f\t%c\t%s\t%1.4f\t%d\t%d\t%s\t%s\t%s\t%s\n',i,thisTrial.onsetTime,thisTrial.stimDur,thisTrial.maskDur,thisTrial.fixDur,thisTrial.responseKey,thisTrial.responseType,thisTrial.responseTime,correct,char(thisTrial.pseudoStim.stimCount),thisTrial.pseudoStim.stimID,thisTrial.pseudoStim.stimType, thisTrial.pseudoStim.wordRelation, char(thisTrial.pseudoStim.fileName));
            fprintf(fidDataBackup,'%d\t%3.2f\t%1.4f\t%1.4f\t%3.4f\t%c\t%s\t%1.4f\t%d\t%d\t%s\t%s\t%s\n',i,thisTrial.onsetTime,thisTrial.stimDur,thisTrial.maskDur,thisTrial.fixDur,thisTrial.responseKey,thisTrial.responseType,thisTrial.responseTime,correct,char(thisTrial.pseudoStim.stimCount),thisTrial.pseudoStim.stimType, thisTrial.pseudoStim.wordRelation, char(thisTrial.pseudoStim.fileName));

            %Print completed stims
            fprintf(fidCompleted,'%d\t%3.2f\t%1.4f\t%1.4f\t%3.4f\t%c\t%s\t%1.4f\t%d\t%d\t%s\t%s\t%s\n',i,thisTrial.onsetTime,thisTrial.stimDur,thisTrial.maskDur,thisTrial.fixDur,thisTrial.responseKey,thisTrial.responseType,thisTrial.responseTime,correct,char(thisTrial.pseudoStim.stimCount),thisTrial.pseudoStim.stimType, thisTrial.pseudoStim.wordRelation, char(thisTrial.pseudoStim.fileName));
            fprintf(fidCompletedBackup,'%d\t%3.2f\t%1.4f\t%1.4f\t%3.4f\t%c\t%s\t%1.4f\t%d\t%d\t%s\t%s\t%s\n',i,thisTrial.onsetTime,thisTrial.stimDur,thisTrial.maskDur,thisTrial.fixDur,thisTrial.responseKey,thisTrial.responseType,thisTrial.responseTime,correct,char(thisTrial.pseudoStim.stimCount),thisTrial.pseudoStim.stimType, thisTrial.pseudoStim.wordRelation, char(thisTrial.pseudoStim.fileName));
            %Set keyfound to 0 for nex trial
            keyFound = 0;

        end

        %If resuming fill information for trial before the interuption
        if resume
            %Read completed stims list
            fclose(fidCompleted);
            fidReadTrials = fopen(stimCompleted,'r');

            %create an array of each line from completed stims
            getCT = textscan(fidReadTrials,'%[^\n\r]');
            getCT = getCT{:};

            %For all trials before most recent interuption create trial object
            for i = 1:(num-1)

                %Get  trial info, split it and also get stimuli information
                line = getCT{i};
                data=strsplit(line,'\t');
                stim = stimuli(i);

                %Add trial to completed trials and using split array set
                %appropriate field values
                completedTrials(i) = pseudoTrial(stim);
                completedTrials(i).onsetTime = data{2};
                completedTrials(i).stimDur = str2double(data{3});
                completedTrials(i).maskDur = str2double(data{4});
                completedTrials(i).fixDur = str2double(data{5});
                completedTrials(i).responseKey = data{6};
                completedTrials(i).responseType = data{7};
                completedTrials(i).responseTime = str2double(data{8});
            end
        end

        %Analysis
        printData(completedTrials,phase,fileName,consistentStims,inconsistentStims,studyStims,realButton,pseudoButton);
        sca();
        ListenChar(0);
        fprintf('Block completed successfully');
        exit(); %added so when launching from command line matlab is closed on completion of the block

    catch error
        sca();
        ListenChar(0);
        err = error;
        disp(err);
        disp(err.message);
        disp(err.stack);
        disp(err.stack(1));
        disp(err.identifier);
        fprintf('An Error Occured\n')
    end
