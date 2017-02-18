function pseudoExp( expmode, subcode, session, phase, block, button, resume )
    try % try catch block to make sure everything closes properly on a crash

        % set rootpath and clear workspace
        % clear();
        rootPath = pwd;
        fprintf(rootPath);
        rootPath = strcat(rootPath, '/');
        rightPath = strcat(rootPath, 'RUNEXP.m');
        assert( (exist(rightPath, 'file') == 2), 'Early Error: you are in the wrong directory' );

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

        % set keys for real and pseudo stimuli
        if strcmp(button, 'one')
            realButton = '1';      
            pseudoButton = '2';
        elseif strcmp(button, 'two')
            realButton = '2';
            pseudoButton = '1';
        else
            error('Unexpected button type');
        end

        % check whether it's test phase or word block
        isTest = strcmp(phase,'test');
        if strcmp(block, 'word') || strcmp(block,'word1') || strcmp(block,'word2')
            isWord = 1;
        else
          isWord = 0;
        end

        % setup sound files for correct/incorrect trials and TMS discharge 
        
        % correct sound
        % read the file containing the sound
        sound = 'right.wav';
        [y, freq] = audioread(sound);

        % transpose and obtain the number of channels for the sound
        wavedata = y';
        nrchannels = size(wavedata,1);

        % intialize sound drivers and and to buffer
        InitializePsychSound(1);
        right = PsychPortAudio('Open', [], [], 1, freq, nrchannels);
        PsychPortAudio('FillBuffer', right, wavedata);

        % incorrect sound
        sound = 'wrong.wav';
        [y, freq] = audioread(sound);
        wavedata = y';
        nrchannels = size(wavedata,1);
        wrong = PsychPortAudio('Open', [], [], 1, freq, nrchannels);
        PsychPortAudio('FillBuffer', wrong, wavedata);

        % discharge sound
        sound = 'discharge.wav';
        [y, freq] = audioread(sound);
        wavedata = y';
        nrchannels = size(wavedata,1);
        discharge = PsychPortAudio('Open', [], [], 1, freq, nrchannels);
        PsychPortAudio('FillBuffer', discharge, wavedata);

        % intialize experimental settings
        optimalS = 0.0168;
        stimdurS = 0.300-optimalS;  % stimulus duration (seconds)
        maskdurS = 0.200-optimalS;  % noise mask duration (seconds)
        bglumRGB = 255;             % background luminance (RGB)
        fixRGB = 0;                 % fixation colour (RGB)
        lineLength = 28;            % fixation line length (pixels)
        lineWidth = 3;              % fixation line width (pixels)
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
        % set args in a standard format
        [phase, block] = checkArgs(phase, block);
        % set fixation duration and number of trials
        [numTrials, itrialiS] = setParams(phase, block);
        isTest = strcmpi(phase, 'test');

        % get screen numbers for all screens connected to computer
        screens = Screen('Screens');

        % draw to the external screen when another monitor is connected
        screenNumber = max(screens);

        % call keyboardCheck function to preload mex file
        [~] = KbCheck;
        [~,~,~] = KbWait;

        % create empty trials to be filled in later
        for i = 1:numTrials  % populate dummy structures
            stim = pseudoStim('');
            thisTrial = pseudoTrial(stim);
            completedTrials(i) = thisTrial;
        end

        % set the appropriate file paths to get legends and stims
        % as well as record data and back ups
        [stimPath, legPath, optseqFilepath] = setPaths(block, subcode, session, phase);
        disp(optseqFilepath);
        % set path for optseq data
        fileName=[ 'Data/' subcode '/SESSION_' int2str(session) '/' upper(block)  '/pseudoexp_' subcode '_' int2str(session) '_' phase '_' block '.log' ];
        % fprintf('filename: %s\n', fileName);
        consistentStims = [ 'Data/' subcode '/SESSION_' int2str(session) '/' upper(block) '/CONSISTENT_STIMS/pseudoexp_' subcode '_' int2str(session) '_' phase '_' block '_consistentStims.txt' ];
        inconsistentStims = [ 'Data/' subcode '/SESSION_' int2str(session) '/' upper(block)  '/CONSISTENT_STIMS/pseudoexp_' subcode '_' int2str(session) '_' phase '_' block '_inconsistentStims.txt' ];
        % stimOrder = [ 'Data/' subcode '/SESSION_' int2str(session) '/COMPLETED_TRIALS/pseudoexp_' subcode '_' int2str(session) '_' phase '_' block '_stimOrder.txt' ];
        stimCompleted = [ 'Data/' subcode '/SESSION_' int2str(session) '/' upper(block)  '/COMPLETED_TRIALS/pseudoexp_' subcode '_' int2str(session) '_' phase '_' block '_stimCompleted.txt' ];

        % get the date and time to tag back ups
        date = clock;
        date = num2str(date);
        date = date(find(~isspace(date)));

        % orderBackup = [ 'Data/' subcode '/SESSION_' int2str(session) '/BACKUP/pseudoexp_' subcode '_' int2str(session) '_' phase '_' block '_stimOrder_' date '.txt' ];
        completedBackup = [ 'Data/' subcode '/SESSION_' int2str(session) '/' upper(block)  '/BACKUP/pseudoexp_' subcode '_' int2str(session) '_' phase '_' block '_stimCompleted_' date '.txt' ];
        dataBackup = [ 'Data/' subcode '/SESSION_' int2str(session) '/' upper(block)  '/BACKUP/pseudoexp_' subcode '_' int2str(session) '_' phase '_' block '_' date '.log'];

        % check to see if it's testphase and if it is get consistent stims
        % from the study phase
        if isTest
            studyStims = [ 'Data/' subcode '/SESSION_' int2str(session) '/' upper(block)  '/CONSISTENT_STIMS/pseudoexp_' subcode '_' int2str(session) '_Study_' block '_consistentStims.txt' ];
        else
            studyStims = [];
        end

        % check if we are resuming and set file permissions accordingly
        if resume
            % set file permissions when resuming
            fid=fopen(fileName, 'a');
            fprintf('fid: %d', fid);
            % fidOrder = fopen(stimOrder,'r');
            fidCompleted = fopen(stimCompleted,'r');
            copyfile(stimCompleted,completedBackup)
            fidCompletedBackup = fopen(completedBackup,'a');
            fidDataBackup = fopen(dataBackup,'w');

            % write participant information into results back up
            fprintf(fidDataBackup,'SUBJECT\t%s\n', subcode);
            fprintf(fidDataBackup,'TIME\t%s\n', datestr(now));
            fprintf(fidDataBackup,'SESSION\t%d\n', session);
            fprintf(fidDataBackup,'PHASE\t%s\n', phase);
            fprintf(fidDataBackup,'BLOCK\t%s\n', block);
            fprintf(fidDataBackup,'BUTTON\t%s\n', button);
            fprintf(fidDataBackup,'\nTrial\tOnset\tStimDur\tMaskDur\tFixDur\tKeyPress\tResponseType\tRxnTime\tAccuracy\tDispCount\tStimulus\tStimulusType\tStimulusCategory\tFilename\n');
       
        else
            fprintf('%s\n', dataBackup);
            [fid, err] = fopen(fileName, 'w');  %% is err doing anything here??
            % fidOrder = fopen(stimOrder,'w');
            fidCompleted = fopen(stimCompleted,'w');
            % fidOrderBackup = fopen(orderBackup,'w');
            fidCompletedBackup = fopen(completedBackup,'w');
            fidDataBackup = fopen(dataBackup,'w');

            fprintf(fid,'SUBJECT\t%s\n', subcode);
            fprintf(fid,'TIME\t%s\n', datestr(now));
            fprintf(fid,'SESSION\t%d\n', session);
            fprintf(fid,'PHASE\t%s\n', phase);
            fprintf(fid,'BLOCK\t%s\n', block);
            fprintf(fid,'BUTTON\t%s\n', button);
            fprintf(fid,'\nTrial\tOnset\tStimDur\tMaskDur\tFixDur\tKeyPress\tResponseType\tRxnTime\tAccuracy\tDispCount\tStimulus\tStimulusType\tSimulusCategory\tFilename\n');

            fprintf('%s\n', fidDataBackup);
            fprintf(fidDataBackup,'SUBJECT\t%s\n', subcode);
            fprintf(fidDataBackup,'TIME\t%s\n', datestr(now));
            fprintf(fidDataBackup,'SESSION\t%d\n', session);
            fprintf(fidDataBackup,'PHASE\t%s\n', phase);
            fprintf(fidDataBackup,'BLOCK\t%s\n', block);
            fprintf(fidDataBackup,'BUTTON\t%s\n', button);
            fprintf(fidDataBackup,'\nTrial\tOnset\tStimDur\tMaskDur\tFixDur\tKeyPress\tResponseType\tRxnTime\tAccuracy\tDispCount\tStimulus\tStimulusType\tStimulusCategory\tFilename\n');
        end
        
        % check if legend file exists and read it
        metaDataPath = strcat(legPath,'csv');
        assert( (exist(metaDataPath,'file') == 2), 'File %s does not exist', metaDataPath );
        metaData = fopen(metaDataPath,'r'); %%%%%%%LEGEND DATA%%%%%%%% 
        optseqData = fopen(optseqFilepath, 'r'); %%%%%%%OPSEQ DATA%%%%%%%%
        
        % BELOW WE ARE SORTING IMAGE TYPES FROM THE LEGEND FILE INTO ARRAYS
        % SO WE CAN PASS THE APPROPRIATE FILENAME BASED ON OPTSEQ DATA! :D
        
        % ONLY DO THIS FOR TEST PHASE!
        if strcmp(phase, 'Test')
            disp('ASDFASDFASDFASDFA');
            % array of real, study filenames
            arr1 = [];
            % array of real, novel filenames
            arr2 = [];
            % array of real, orthographic
            arr3 = [];
            % array of pseudo, study filenames
            arr4 = [];
            % array of pseudo, novel filenames
            arr5 = [];
            % array of pseudo, ortho filenames
            arr6 = [];

            for i = 1:numTrials
                thisRecord = fgetl(metaData);
                recordData = regexp(thisRecord,',','split');

                imageFileName = recordData(1);
                % real or pseudo
                reudo = char(recordData(2));
                % rep, novel, ortho
                rovel = char(recordData(3));

                if strcmp(block, 'Word1') || strcmp(block,'Word2')
                    % we arrive at 1 type [real, study]
                    if strcmp(reudo(1),'r') && strcmp(rovel(1),'s')
                        arr1 = [arr1 imageFileName];
                    % we arrive at 2 type [real, novel]
                    elseif strcmp(reudo(1),'r') && strcmp(rovel(1),'n')
                        arr2 = [arr2 imageFileName];
                    % we arrive at 3 type [real, orth]
                    elseif strcmp(reudo(1),'r') && strcmp(rovel(1),'o')
                        arr3 = [arr3 imageFileName];
                    % we arrive at 4 type [pseudo, study]
                    elseif strcmp(reudo(1),'p') && strcmp(rovel(1),'s')
                        arr4 = [arr4 imageFileName];
                    % we arrive at 5 type [pseudo, novel]
                    elseif strcmp(reudo(1),'p') && strcmp(rovel(1),'n')
                        arr5 = [arr5 imageFileName];
                    % we arrive at 6 type [pseudo, ortho]
                    elseif strcmp(reudo(1),'p') && strcmp(rovel(1),'o')
                        arr6 = [arr6 imageFileName];
                    end
                else % THIS IS FOR Object, Faces!!!!
                    % we arrive at 1 type [real, study]
                    if strcmp(reudo(1),'r') && strcmp(rovel(1),'s')
                        arr1 = [arr1 imageFileName];
                    % we arrive at 2 type [real, novel]
                    elseif strcmp(reudo(1),'r') && strcmp(rovel(1),'n')
                        arr2 = [arr2 imageFileName];
                    % we arrive at 3 type [pseudo, study]
                    elseif strcmp(reudo(1),'p') && strcmp(rovel(1),'s')
                        arr3 = [arr3 imageFileName];
                    % we arrive at 4 type [pseudo, novel]
                    elseif strcmp(reudo(1),'p') && strcmp(rovel(1),'n')
                        arr4 = [arr4 imageFileName];
                    end 
                end
            end
            % CLOSE THE LEGEND!!!!!
            fclose(metaData);
            
            % REOPEN SO TO MAKE HAPPY thisMeta :(
            metaData = fopen(metaDataPath,'r');
        
            % array holding counts on stimulusTypes
            count2 = 1; count3 = 1; count4 = 1; 
            count5 = 1; count6 = 1; count7 = 1;

            for i = 1:numTrials
                % necessary to satisfy thisMeta
                thisRecord = fgetl(metaData);
                
                % read the optseq line
                thisOptseqData = fgetl(optseqData);

                % scan data from optseq into local var
                scanValues = textscan(thisOptseqData, '%d %d %d %s %s %s');

                % get type from opsec
                optseqType = scanValues{2};

                if strcmp(block, 'Word1') || strcmp(block,'Word2')
                    if optseqType==0
                        filename = 'null';
                        reudo = 'null';
                    elseif optseqType==1
                        filename = strcat(arr1(count2),'.real.png');
                        reudo = 'real';
                        count2 = count2 + 1;
                    elseif optseqType==2
                        filename = strcat(arr2(count3),'.real.png');
                        reudo = 'real';
                        count3 = count3 + 1;
                    elseif optseqType==3
                        filename = strcat(arr3(count4),'.real.png');
                        count4 = count4 + 1;
                        reudo = 'real';
                    elseif optseqType==4
                        filename = strcat(arr4(count5),'.pseudo.png');
                        count5 = count5 + 1;
                        reudo = 'pseudo';
                    elseif optseqType==5
                        filename = strcat(arr5(count6),'.pseudo.png');
                        reudo = 'pseudo';
                        count6 = count6 + 1;
                    elseif optseqType==6
                        filename = strcat(arr6(count7),'.pseudo.png');
                        reudo = 'pseudo';
                        count7 = count7 + 1;
                    end
                else
                    if optseqType==0
                        filename = 'null';
                        reudo = 'null';
                    elseif optseqType==1
                        filename = strcat(arr1(count2),'.real.png');
                        count2 = count2 + 1;
                        reudo = 'real';
                    elseif optseqType==2
                        filename = strcat(arr2(count3),'.real.png');
                        count3 = count3 + 1;
                        reudo = 'real';
                    elseif optseqType==3
                        filename = strcat(arr3(count4),'.pseudo.png');
                        count4 = count4 + 1;
                        reudo = 'pseudo';
                    elseif optseqType==4
                        filename = strcat(arr4(count5),'.pseudo.png');
                        count5 = count5 + 1;
                        reudo = 'pseudo';
                    end
                end

                % create comma delimited input for creating a stimulus
                thisMeta = [block ',' phase ',' thisRecord];
                stim = pseudoStimTest(thisMeta, filename, reudo);

                % assign correct key to stimulus object
                if stim.isReal == 1         
                       stim.correctKey = realButton;
                else
                       stim.correctKey = pseudoButton;
                end
                stimuli(i) = stim; %#ok<*AGROW>
            end
            fclose(metaData); 
        
        % PRACTICE, STUDY PHASES
        else
            % OPEN THE LEGEND
            metaData = fopen(metaDataPath,'r');

            % put the stimulus information into the trials
            for i = 1:numTrials
                thisRecord = fgetl(metaData);
                
                % create comma delimited input for creating a stimulus
                thisMeta = [block ',' phase ',' thisRecord];
                stim = pseudoStim(thisMeta);

                % assign correct key to stimulus object
                if stim.isReal == 1         
                       stim.correctKey = realButton;
                else
                       stim.correctKey = pseudoButton;
                end
                stimuli(i) = stim; %#ok<*AGROW>
            end
            fclose(metaData);
        
        end

        % set display counts for stimuli; starts from second stimulus and 
        % compares to all previous stimuli, then assigns the appropriate
        % display count
        for i = 2:numel(stimuli)
            % boolean for repeat; set to false by default
            repeat = false;
            for j = 1:(i-1)
                % if stim.ID of current stimuli i matches any previous stimuli
                if strcmp(stimuli(i).stimID,stimuli(j).stimID)
                    % set repeat true
                    repeat = true;
                end
            end
            % if stimulus has been shown before set stimCount to 2 
            % otherwise set it to 1
            if repeat
                stimuli(i).stimCount = 2;
            else
                stimuli(i).stimCount = 1;
            end
        end

         % if resuming go to correct trial otherwise start from trial 1
         if ~resume
             num = 1;
         else
             % read the completed trials file and get the total number of 
             % trials completed
             getCompleted = textscan(fidCompleted,'%[^\n\r]');
             getCompleted = getCompleted{:};
             % we need total completed + 1 to get the starting point
             num = numel(getCompleted)+1;
             fclose(fidCompleted);
             % append trial information to completed trials file
             fidCompleted = fopen(stimCompleted,'a');
         end

        % open screen (psychtoolbox)
        [winID,winRect] = Screen('OpenWindow',screenNumber,bglumRGB);

        % set blend function for transparency
        Screen('BlendFunction', winID, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

        % here we are preloading the images and converting them to textures
        for i = 1:numTrials
            % get current stimuli
            thisStim = stimuli(i);
            % set path
            if ~strcmp(thisStim.fileName, 'null')
                targetPath=strcat(rootPath, stimPath, thisStim.fileName);
                % make sure it is string
                stringie = char(targetPath);
                % load image
                [img, rect, alpha] = imread(stringie, 'png');
                % words and faces are in RGB colorspace, objects in grayscale
                if isWord
                  bgColor = [1 1 1];
                else
                  img = repmat(img,[1 1 3]);
                end

                % alphaMask = im2double(alpha);
                % imgComposite = im2uint8(double(img).*alphaMask);
                r = img(:, :, 1);
                g = img(:, :, 2);
                b = img(:, :, 3);
                img = cat(3, r, g, b, alpha);
                % disp(alpha);
                % convert image to a Psychtoolbox texture for faster loading
                tex = Screen('MakeTexture', winID, img);
                % store it in an array
                stimulusImage{i} = tex;
            end
        end

      % HideCursor;
        ListenChar(2);
      % fprintf('about to focus window');
      % Screen('MATLABToFront', 0); %focus on matlab command window

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
        DrawFormattedText(winID, 'Press ''q'' to quit', 'center', centreY+150, 0); %quitKeyQ
        Screen('Flip',winID);
        KbStrokeWait;

        keyFound = 0;
        Screen('DrawLine',winID,fixRGB,(centreX-lineLength),centreY,(centreX+lineLength),centreY, lineWidth);
        Screen('DrawLine',winID,fixRGB,centreX,(centreY-lineLength),centreX,(centreY+lineLength), lineWidth);
        realFixStart = Screen('Flip',winID);
        experimentStart = realFixStart;
        stimStart = realFixStart + itrialiS + 0.0166;
        
        disp(phase);
        
        switch(phase)
        
        % % % % % % % % % %
        % PRACTICE PHASE  %
        % % % % % % % % % %
        
            case('Practice')
                disp('PACAPACPAC');
        
            for i = num:numTrials
                % pick stimulus, create trial and add it to completed trials
                thisStim = stimuli(i);
                thisTrial = pseudoTrial(thisStim);

                if strcmp(thisStim.fileName, 'null')
                    % display fixation between trials
                    Screen('FillRect',winID,bglumRGB);
                    Screen('DrawLine',winID,fixRGB,(centreX-lineLength),centreY,(centreX+lineLength),centreY, lineWidth);
                    Screen('DrawLine',winID,fixRGB,centreX,(centreY-lineLength),centreX,(centreY+lineLength), lineWidth);
                    realStimStart = Screen('Flip',winID,stimStart);
                    disp('YAY');
                else
                    % show stimuli and also get fixation duration and stim start
                    Screen('DrawTexture', winID, stimulusImage{i});
                    realStimStart = Screen('Flip',winID,stimStart);
                    disp('REG');
                end

                realFixDur = realStimStart - realFixStart;
                
                PsychPortAudio('Start', discharge, 1, 0, 1);

                % wait 150 ms before looking for key stroke
                pause(.150);
                if strcmpi(phase,'practice')
                    [key,keyTime] = keyWatch(stimdurS-0.250, thisStim.correctKey, right, wrong);
                else
                    [key,keyTime] = keyWatch(stimdurS-0.250);
                end
                % if a key was pressed, don't check for any more this trial
                if keyTime ~=0
                    keyFound = 1;
                end

                % show mask and get duration of stim and mask start time
                maskStart = realStimStart + stimdurS;
                mask=round(255*rand(winRect(4),winRect(3)));
                Screen('PutImage', winID, mask);
                realMaskStart = Screen('Flip',winID,maskStart);

                % if the reponse has been recorded do not check for input
                if ~keyFound
                    if strcmpi(phase,'practice')
                        [key,keyTime] = keyWatch(maskdurS, thisStim.correctKey, right, wrong);
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

                if strcmp(key, 'q')  % quit if q was pressed
                  sca();
                  ListenChar(0);
                  fprintf('### Block terminated early ###\n\n');
                  sca;
                elseif keyTime == 0  % if no response
                    responseTime = 0;
                    key = '0';
                    if strcmpi(phase,'practice')
                        PsychPortAudio('Start', wrong, 1, 0, 1);  % wrong sound
                    end
                else                 % else calculate response time
                    responseTime = keyTime - realStimStart;
                end

                % record onset
                onset = realStimStart-experimentStart;

                % record trial information
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
                correct = (thisTrial.pseudoStim.correctKey == thisTrial.responseKey);

                % print trial info to console to monitor perfomance during fMRI
                fprintf('\nTrial\tOnset\tStimDur\tMaskDur\tFixDur\n');
                fprintf('%d\t\t%3.2f\t%1.4f\t%1.4f\t%3.4f\n\n',i,thisTrial.onsetTime,thisTrial.stimDur,thisTrial.maskDur,thisTrial.fixDur);
                fprintf('Trial:\t%d\nResponseType:\t%s\nRxnTime:\t%1.4f\nAccuracy:\t%d\nDispCount:\t%d\nStimulus:\t%s\nStimulusType:\t%s\nStimulusCategory:\t%s\n\n',i,thisTrial.responseType,thisTrial.responseTime,correct,char(thisTrial.pseudoStim.stimCount),thisTrial.pseudoStim.stimID,thisTrial.pseudoStim.stimType, thisTrial.pseudoStim.wordRelation);

                % print results and backup
                fprintf(fid,'%d\t%3.2f\t%1.4f\t%1.4f\t%3.4f\t%c\t%s\t%1.4f\t%d\t%d\t%s\t%s\t%s\t%s\n',i,thisTrial.onsetTime,thisTrial.stimDur,thisTrial.maskDur,thisTrial.fixDur,thisTrial.responseKey,thisTrial.responseType,thisTrial.responseTime,correct,char(thisTrial.pseudoStim.stimCount),thisTrial.pseudoStim.stimID,thisTrial.pseudoStim.stimType, thisTrial.pseudoStim.wordRelation, char(thisTrial.pseudoStim.fileName));
                fprintf(fidDataBackup,'%d\t%3.2f\t%1.4f\t%1.4f\t%3.4f\t%c\t%s\t%1.4f\t%d\t%d\t%s\t%s\t%s\n',i,thisTrial.onsetTime,thisTrial.stimDur,thisTrial.maskDur,thisTrial.fixDur,thisTrial.responseKey,thisTrial.responseType,thisTrial.responseTime,correct,char(thisTrial.pseudoStim.stimCount),thisTrial.pseudoStim.stimType, thisTrial.pseudoStim.wordRelation, char(thisTrial.pseudoStim.fileName));

                % print completed stims
                fprintf(fidCompleted,'%d\t%3.2f\t%1.4f\t%1.4f\t%3.4f\t%c\t%s\t%1.4f\t%d\t%d\t%s\t%s\t%s\n',i,thisTrial.onsetTime,thisTrial.stimDur,thisTrial.maskDur,thisTrial.fixDur,thisTrial.responseKey,thisTrial.responseType,thisTrial.responseTime,correct,char(thisTrial.pseudoStim.stimCount),thisTrial.pseudoStim.stimType, thisTrial.pseudoStim.wordRelation, char(thisTrial.pseudoStim.fileName));
                fprintf(fidCompletedBackup,'%d\t%3.2f\t%1.4f\t%1.4f\t%3.4f\t%c\t%s\t%1.4f\t%d\t%d\t%s\t%s\t%s\n',i,thisTrial.onsetTime,thisTrial.stimDur,thisTrial.maskDur,thisTrial.fixDur,thisTrial.responseKey,thisTrial.responseType,thisTrial.responseTime,correct,char(thisTrial.pseudoStim.stimCount),thisTrial.pseudoStim.stimType, thisTrial.pseudoStim.wordRelation, char(thisTrial.pseudoStim.fileName));
                % set keyfound to 0 for next trial
                keyFound = 0;

            end

            % % % % % % % %
            % STUDY PHASE %
            % % % % % % % %
            %
            % TMS pulse
            % no NULL trials
            % no opseq
            %
            
            case('Study')

            for i = num:numTrials
                % pick stimulus, create trial and add it to completed trials
                thisStim = stimuli(i);
                thisTrial = pseudoTrial(thisStim);

                % show stimuli and also get fixation duration and stim start
                Screen('DrawTexture', winID, stimulusImage{i});
                realStimStart = Screen('Flip',winID,stimStart);
                disp('REG');

                realFixDur = realStimStart - realFixStart;

                % use TMS
                if useTMS
                    Datapixx('SetDoutValues', 1); % store trigger value in memory
                    Datapixx('RegWrVideoSync');   % make DataPixx send pulse on next flip
                    Datapixx('SetDoutValues', 0); % reset trigger value in memory
                    Datapixx('RegWrRd');          % send trigger value
                end

                % if no TMS and in study phase play mock discharge sound on
                % stimulus onset
                if ~expmode && ~strcmpi(phase,'practice')
                    PsychPortAudio('Start', discharge, 1, 0, 1);
                end

                % wait 150 ms before looking for key stroke
                pause(.150);
                if strcmpi(phase,'practice')
                    [key,keyTime] = keyWatch(stimdurS-0.250, thisTrial.pseudoStim.correctKey, right, wrong);
                else
                    [key,keyTime] = keyWatch(stimdurS-0.250);
                end
                % if a key was pressed, don't check for any more this trial
                if keyTime ~=0
                    keyFound = 1;
                end

                % show mask and get duration of stim and mask start time
                maskStart = realStimStart + stimdurS;
                mask=round(255*rand(winRect(4),winRect(3)));
                Screen('PutImage', winID, mask);
                realMaskStart = Screen('Flip',winID,maskStart);

                % if the reponse has been recorded do not check for input
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
                    [key,keyTime] = keyWatch(itrialiS);
                end

                % get stimulus timing data
                realStimDur = realMaskStart - realStimStart;
                stimStart = realFixStart + itrialiS;
                realMaskDur = realFixStart - realMaskStart;

                if strcmp(key, 'q')  % quit if q was pressed
                  sca();
                  ListenChar(0);
                  fprintf('### Block terminated early ###\n\n');
                  sca;
                elseif keyTime == 0  % if no response
                    responseTime = 0;
                    key = '0';
                else                 % else calculate response time
                    responseTime = keyTime - realStimStart;
                end

                % record onset
                onset = realStimStart-experimentStart;

                % record trial information
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
                correct = (thisTrial.pseudoStim.correctKey == thisTrial.responseKey);

                % print trial info to console to monitor perfomance during fMRI
                fprintf('\nTrial\tOnset\tStimDur\tMaskDur\tFixDur\n');
                fprintf('%d\t\t%3.2f\t%1.4f\t%1.4f\t%3.4f\n\n',i,thisTrial.onsetTime,thisTrial.stimDur,thisTrial.maskDur,thisTrial.fixDur);
                fprintf('Trial:\t%d\nResponseType:\t%s\nRxnTime:\t%1.4f\nAccuracy:\t%d\nDispCount:\t%d\nStimulus:\t%s\nStimulusType:\t%s\nStimulusCategory:\t%s\n\n',i,thisTrial.responseType,thisTrial.responseTime,correct,char(thisTrial.pseudoStim.stimCount),thisTrial.pseudoStim.stimID,thisTrial.pseudoStim.stimType, thisTrial.pseudoStim.wordRelation);

                % print results and backup
                fprintf(fid,'%d\t%3.2f\t%1.4f\t%1.4f\t%3.4f\t%c\t%s\t%1.4f\t%d\t%d\t%s\t%s\t%s\t%s\n',i,thisTrial.onsetTime,thisTrial.stimDur,thisTrial.maskDur,thisTrial.fixDur,thisTrial.responseKey,thisTrial.responseType,thisTrial.responseTime,correct,char(thisTrial.pseudoStim.stimCount),thisTrial.pseudoStim.stimID,thisTrial.pseudoStim.stimType, thisTrial.pseudoStim.wordRelation, char(thisTrial.pseudoStim.fileName));
                fprintf(fidDataBackup,'%d\t%3.2f\t%1.4f\t%1.4f\t%3.4f\t%c\t%s\t%1.4f\t%d\t%d\t%s\t%s\t%s\n',i,thisTrial.onsetTime,thisTrial.stimDur,thisTrial.maskDur,thisTrial.fixDur,thisTrial.responseKey,thisTrial.responseType,thisTrial.responseTime,correct,char(thisTrial.pseudoStim.stimCount),thisTrial.pseudoStim.stimType, thisTrial.pseudoStim.wordRelation, char(thisTrial.pseudoStim.fileName));

                % print completed stims
                fprintf(fidCompleted,'%d\t%3.2f\t%1.4f\t%1.4f\t%3.4f\t%c\t%s\t%1.4f\t%d\t%d\t%s\t%s\t%s\n',i,thisTrial.onsetTime,thisTrial.stimDur,thisTrial.maskDur,thisTrial.fixDur,thisTrial.responseKey,thisTrial.responseType,thisTrial.responseTime,correct,char(thisTrial.pseudoStim.stimCount),thisTrial.pseudoStim.stimType, thisTrial.pseudoStim.wordRelation, char(thisTrial.pseudoStim.fileName));
                fprintf(fidCompletedBackup,'%d\t%3.2f\t%1.4f\t%1.4f\t%3.4f\t%c\t%s\t%1.4f\t%d\t%d\t%s\t%s\t%s\n',i,thisTrial.onsetTime,thisTrial.stimDur,thisTrial.maskDur,thisTrial.fixDur,thisTrial.responseKey,thisTrial.responseType,thisTrial.responseTime,correct,char(thisTrial.pseudoStim.stimCount),thisTrial.pseudoStim.stimType, thisTrial.pseudoStim.wordRelation, char(thisTrial.pseudoStim.fileName));
                % set keyfound to 0 for next trial
                keyFound = 0;

            end

            % % % % % % % %
            % TEST PHASE  %
            % % % % % % % %
            %
            % NO TMS pulse
            % Use NULL trials and opseq
            % No mask after NULL trials
            %
            
            case('Test')

            for i = num:numTrials
                % pick stimulus, create trial and add it to completed trials
                thisStim = stimuli(i);
                thisTrial = pseudoTrial(thisStim);

                % Display fixation point for null trial
                if strcmp(thisStim.fileName, 'null')
                    % display fixation between trials
                    Screen('FillRect',winID,bglumRGB);
                    Screen('DrawLine',winID,fixRGB,(centreX-lineLength),centreY,(centreX+lineLength),centreY, lineWidth);
                    Screen('DrawLine',winID,fixRGB,centreX,(centreY-lineLength),centreX,(centreY+lineLength), lineWidth);
                    realStimStart = Screen('Flip',winID,stimStart);
                    realFixDur = realStimStart - realFixStart;
                else
                    % show stimuli and also get fixation duration and stim start
                    Screen('DrawTexture', winID, stimulusImage{i});
                    realStimStart = Screen('Flip',winID,stimStart);
                    realFixDur = realStimStart - realFixStart;
                    
                    % wait 150 ms before looking for key stroke
                    pause(.150);
                    if strcmpi(phase,'practice')
                        [key,keyTime] = keyWatch(stimdurS-0.250, thisTrial.pseudoStim.correctKey, right, wrong);
                    else
                        [key,keyTime] = keyWatch(stimdurS-0.250);
                    end
                    % if a key was pressed, don't check for any more this trial
                    if keyTime ~=0
                        keyFound = 1;
                    end

                    % show mask and get duration of stim and mask start time
                    maskStart = realStimStart + stimdurS;
                    mask=round(255*rand(winRect(4),winRect(3)));
                    Screen('PutImage', winID, mask);
                    realMaskStart = Screen('Flip',winID,maskStart);

                    % if the reponse has been recorded do not check for input
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

                if strcmp(key, 'q')  % quit if q was pressed
                  sca();
                  ListenChar(0);
                  fprintf('### Block terminated early ###\n\n');
                  sca;
                elseif keyTime == 0  % if no response
                    responseTime = 0;
                    key = '0';
                    if strcmpi(phase,'practice')
                        PsychPortAudio('Start', wrong, 1, 0, 1);  % wrong sound
                    end
                else                 % else calculate response time
                    responseTime = keyTime - realStimStart;
                end

                % record onset
                onset = realStimStart - experimentStart;

                % record trial information
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
                correct = (thisTrial.pseudoStim.correctKey == thisTrial.responseKey);

                % print trial info to console to monitor perfomance during fMRI
                fprintf('\nTrial\tOnset\tStimDur\tMaskDur\tFixDur\n');
                fprintf('%d\t\t%3.2f\t%1.4f\t%1.4f\t%3.4f\n\n',i,thisTrial.onsetTime,thisTrial.stimDur,thisTrial.maskDur,thisTrial.fixDur);
                fprintf('Trial:\t%d\nResponseType:\t%s\nRxnTime:\t%1.4f\nAccuracy:\t%d\nDispCount:\t%d\nStimulus:\t%s\nStimulusType:\t%s\nStimulusCategory:\t%s\n\n',i,thisTrial.responseType,thisTrial.responseTime,correct,char(thisTrial.pseudoStim.stimCount),thisTrial.pseudoStim.stimID,thisTrial.pseudoStim.stimType, thisTrial.pseudoStim.wordRelation);

                % print results and backup
                fprintf(fid,'%d\t%3.2f\t%1.4f\t%1.4f\t%3.4f\t%c\t%s\t%1.4f\t%d\t%d\t%s\t%s\t%s\t%s\n',i,thisTrial.onsetTime,thisTrial.stimDur,thisTrial.maskDur,thisTrial.fixDur,thisTrial.responseKey,thisTrial.responseType,thisTrial.responseTime,correct,char(thisTrial.pseudoStim.stimCount),thisTrial.pseudoStim.stimID,thisTrial.pseudoStim.stimType, thisTrial.pseudoStim.wordRelation, char(thisTrial.pseudoStim.fileName));
                fprintf(fidDataBackup,'%d\t%3.2f\t%1.4f\t%1.4f\t%3.4f\t%c\t%s\t%1.4f\t%d\t%d\t%s\t%s\t%s\n',i,thisTrial.onsetTime,thisTrial.stimDur,thisTrial.maskDur,thisTrial.fixDur,thisTrial.responseKey,thisTrial.responseType,thisTrial.responseTime,correct,char(thisTrial.pseudoStim.stimCount),thisTrial.pseudoStim.stimType, thisTrial.pseudoStim.wordRelation, char(thisTrial.pseudoStim.fileName));

                % print completed stims
                fprintf(fidCompleted,'%d\t%3.2f\t%1.4f\t%1.4f\t%3.4f\t%c\t%s\t%1.4f\t%d\t%d\t%s\t%s\t%s\n',i,thisTrial.onsetTime,thisTrial.stimDur,thisTrial.maskDur,thisTrial.fixDur,thisTrial.responseKey,thisTrial.responseType,thisTrial.responseTime,correct,char(thisTrial.pseudoStim.stimCount),thisTrial.pseudoStim.stimType, thisTrial.pseudoStim.wordRelation, char(thisTrial.pseudoStim.fileName));
                fprintf(fidCompletedBackup,'%d\t%3.2f\t%1.4f\t%1.4f\t%3.4f\t%c\t%s\t%1.4f\t%d\t%d\t%s\t%s\t%s\n',i,thisTrial.onsetTime,thisTrial.stimDur,thisTrial.maskDur,thisTrial.fixDur,thisTrial.responseKey,thisTrial.responseType,thisTrial.responseTime,correct,char(thisTrial.pseudoStim.stimCount),thisTrial.pseudoStim.stimType, thisTrial.pseudoStim.wordRelation, char(thisTrial.pseudoStim.fileName));
                % set keyfound to 0 for next trial
                keyFound = 0;

            end
        
        end

        % if resuming fill information for trial before the interuption
        if resume
            % read completed stims list
            fclose(fidCompleted);
            fidReadTrials = fopen(stimCompleted,'r');

            % create an array of each line from completed stims
            getCT = textscan(fidReadTrials,'%[^\n\r]');
            getCT = getCT{:};

            % for all trials before most recent interuption create trial object
            for i = 1:(num-1)

                % get  trial info, split it and also get stimuli information
                line = getCT{i};
                data=strsplit(line,'\t');
                stim = stimuli(i);

                % add trial to completed trials and using split array set
                % appropriate field values
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

        % analysis
        printData(completedTrials,phase,fileName,consistentStims,inconsistentStims,studyStims,realButton,pseudoButton);
        sca();
        ListenChar(0);
        fprintf('Block completed successfully');

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
