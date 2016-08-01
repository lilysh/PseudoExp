function printData(trials, phase,fileName,consistentStims,inconsistentStims,studyStims,realButton,pseudoButton)    
    
    fid=fopen(fileName, 'a');
    
    numTrials = 0;
    numResponseTrials = 0;
    totalRTTrials = 0;
    correctTrials = 0;
    correctRTTrials = 0;
    consistentTrials = 0;
    consistentRTTrials = 0;
    
    numReal = 0;
    numResponseReal = 0;
    totalRTReal = 0;
    correctReal = 0;
    correctRTReal = 0;
    consistentReal = 0;
    consistentRTReal = 0;
    
    numPseudo = 0;
    numResponsePseudo = 0;
    totalRTPseudo = 0;
    correctPseudo = 0;
    correctRTPseudo = 0;
    consistentPseudo = 0;
    consistentRTPseudo = 0;
    
    numStudy1 = 0;
    numResponseStudy1 = 0;
    totalRTStudy1 = 0;
    correctStudy1 = 0;
    correctRTStudy1 = 0;
    consistentStudy1 = 0;
    consistentRTStudy1 = 0;
    
    numRealStudy1 = 0;
    numResponseRealStudy1 = 0;
    totalRTRealStudy1 = 0;
    correctRealStudy1 = 0;
    correctRTRealStudy1 = 0;
    consistentRealStudy1 = 0;
    consistentRTRealStudy1 = 0;
    
    numPseudoStudy1 = 0;
    numResponsePseudoStudy1 = 0;
    totalRTPseudoStudy1 = 0;
    correctPseudoStudy1 = 0;
    correctRTPseudoStudy1 = 0;
    consistentPseudoStudy1 = 0;
    consistentRTPseudoStudy1 = 0;
    
    numStudy2 = 0;
    numResponseStudy2 = 0;
    totalRTStudy2 = 0;
    correctStudy2 = 0;
    correctRTStudy2 = 0;
    consistentStudy2 = 0;
    consistentRTStudy2 = 0;
    
    numRealStudy2 = 0;
    numResponseRealStudy2 = 0;
    totalRTRealStudy2 = 0;
    correctRealStudy2 = 0;
    correctRTRealStudy2 = 0;
    consistentRealStudy2 = 0; %#ok<*NASGU>
    consistentRTRealStudy2 = 0;
    
    numPseudoStudy2 = 0;
    numResponsePseudoStudy2 = 0;
    totalRTPseudoStudy2 = 0;
    correctPseudoStudy2 = 0;
    correctRTPseudoStudy2 = 0;
    consistentPseudoStudy2 = 0;
    consistentRTPseudoStudy2 = 0;
    
    numStudy = 0;
    numResponseStudy = 0;
    totalRTStudy = 0;
    correctStudy = 0;
    correctRTStudy = 0;
    consistentStudy = 0;
    consistentRTStudy = 0;
    
    numRealStudy = 0;
    numResponseRealStudy = 0;
    totalRTRealStudy = 0;
    correctRealStudy = 0;
    correctRTRealStudy = 0;
    consistentRealStudy = 0;
    consistentRTRealStudy = 0;
    
    numPseudoStudy = 0;
    numResponsePseudoStudy = 0;
    totalRTPseudoStudy = 0;
    correctPseudoStudy = 0;
    correctRTPseudoStudy = 0;
    consistentPseudoStudy = 0;
    consistentRTPseudoStudy = 0;
    
    numOrtho = 0;
    numResponseOrtho = 0;
    totalRTOrtho = 0;
    correctOrtho = 0;
    correctRTOrtho = 0;
    consistentOrtho = 0;
    consistentRTOrtho = 0;
    
    numRealOrtho = 0;
    numResponseRealOrtho = 0;
    totalRTRealOrtho = 0;
    correctRealOrtho = 0;
    correctRTRealOrtho = 0;
    consistentRealOrtho = 0;
    consistentRTRealOrtho = 0;
    
    numPseudoOrtho = 0;
    numResponsePseudoOrtho = 0;
    totalRTPseudoOrtho = 0;
    correctPseudoOrtho = 0;
    correctRTPseudoOrtho = 0;
    consistentPseudoOrtho = 0;
    consistentRTPseudoOrtho = 0;
    
    numNovel = 0;
    numResponseNovel = 0;
    totalRTNovel = 0;
    correctNovel = 0;
    correctRTNovel = 0;
    consistentNovel = 0;
    consistentRTNovel = 0;
    
    numRealNovel = 0;
    numResponseRealNovel = 0;
    totalRTRealNovel = 0;
    correctRealNovel = 0;
    correctRTRealNovel = 0;
    consistentRealNovel = 0;
    consistentRTRealNovel = 0;
    
    numPseudoNovel = 0;
    numResponsePseudoNovel = 0;
    totalRTPseudoNovel = 0;
    correctPseudoNovel = 0;
    correctRTPseudoNovel = 0;
    consistentPseudoNovel = 0;
    consistentRTPseudoNovel = 0;

    %Consistent stims
    stimsC={};
    % Inconsistent stims
    stimsI={};
    response={};
    %Counts
    countT = 0;
    countC = 0;
    countI = 0;
    
    %Get consistent stims in study
    if strcmpi(phase,'study')
        
        %create fid to write lists of stims
        fidC=fopen(consistentStims,'w');
        fidI=fopen(inconsistentStims,'w');
        
        %Nested for loops to compare trials
        for i = 1:numel(trials)
            for j = 1:numel(trials)
                %don't want to compare the same trials
                if i~=j
                    
                    %check if the trials have shown the same stimuli
                    if strcmpi(trials(i).pseudoStim.stimID,trials(j).pseudoStim.stimID)
                        
                        %Check if there is a response
                        if trials(i).responseTime ~= 0
                            
                            %Check if the response is the same in both
                            %trials
                            if (trials(i).responseKey==trials(j).responseKey)   
                                countT = countT + 1;
                                
                                %If consistent reponse make the reponse the
                                %correct one and change stimulus type if
                                %necessary
                                trials(i).pseudoStim.correctKey = trials(i).responseKey;
                                if trials(i).responseKey == pseudoButton
                                    trials(i).pseudoStim.isReal = 0;
                                elseif trials(i).responseKey == realButton
                                    trials(i).pseudoStim.isReal = 1;
                                end
                                
                                %add trial to list of trials that are
                                %consistent
                                trialsAnalyzed(countT) = trials(i);
                                
                                %record stimulus that is consistent if it
                                %has not already been recorded
                                if ~any(ismember(stimsC,trials(i).pseudoStim.stimID))
                                    countC = countC+1;
                                    stimsC{countC} = trials(i).pseudoStim.stimID;
                                    response{countC} = trials(i).responseType;
                                end
                            else
                                %if stim is inconsistent write it into the
                                %other file and if appropriate tag stimuli with no
                                %respones
                                if ~any(ismember(stimsI,trials(i).pseudoStim.stimID))
                                    countI = countI+1;
                                    stimsI{countI} = trials(i).pseudoStim.stimID;
                                    if trials(j).responseTime == 0
                                        responseI{countI}=trials(j).responseType;
                                    else
                                        responseI{countI}='';
                                    end
                                end
                            end
                        else
                            %Since there is no response write to the
                            %inconsistent stimuli file and tag stimuli with
                            %no reponse
                            if ~any(ismember(stimsI,trials(i).pseudoStim.stimID))
                                countI = countI+1;
                                stimsI{countI} = trials(i).pseudoStim.stimID;
                                responseI{countI}=trials(i).responseType;
                            end
                        end
                    end
                end
            end
        end
        %If there are no consistent reponses at all make trialsAnalyzed
        %empty
        if numel(stimsC) == 0
            trialsAnalyzed = [];
        end
    %Check consistency in the test phase    
    elseif strcmpi(phase,'test')
        %Open up the file to be used
        fidC=fopen(consistentStims,'w');
        fidI=fopen(inconsistentStims,'w');
        fidS = fopen(studyStims,'r');
        % read the first line of study
        line = fgetl(fidS);
        %Loop until the end of the study stims file
        while ischar(line)
            %split the line 1 = stimID 2 = response
            stimS=strsplit(line,'\t');
            %loop through the trials until the stimulus is found
            for i = 1:numel(trials)
                if strcmpi(trials(i).pseudoStim.stimID, stimS{1})
                    %Set correct key based on study reponses
                    if strcmpi(stimS{2},'pseudo')
                        trials(i).pseudoStim.correctKey = pseudoButton;
                        trials(i).pseudoStim.isReal = 0;
                    elseif strcmpi(stimS{2},'real')
                        trials(i).pseudoStim.correctKey = realButton;
                        trials(i).pseudoStim.isReal = 1;
                    end
                    %If reponses match add to consistent stims file if not
                    %add to inconsistent stims
                    if strcmpi(trials(i).responseType, stimS{2})
                        countT = countT + 1;
                        trialsAnalyzed(countT) = trials(i);
                        countC = countC + 1;
                        stimsC{countC} = trials(i).pseudoStim.stimID;
                        response{countC} = trials(i).responseType;
                    else
                        countI = countI + 1;
                        stimsI{countI} = trials(i).pseudoStim.stimID;
                        responseI{countI} = trials(i).responseType;
                        
                    end
                end
            end
            line = fgetl(fidS);
        end
        if numel(stimsC) == 0
            trialsAnalyzed = [];
        end
        
    else
        trialsAnalyzed = [];
    end
    %Record consistent stims
    if numel(stimsC) > 0
        for i = 1:numel(stimsC)
            if strcmpi(phase,'study')
                fprintf(fidC,'%s\t%s\n',stimsC{i},response{i});
            else
                fprintf(fidC,'%s\t%s\n',stimsC{i},response{i});
            end
        end
    end
    %Record inconsistent stims
    if numel(stimsI) > 0
        for i = 1:numel(stimsI)
            fprintf(fidI,'%s\t%s\n',stimsI{i},responseI{i});
        end
    end
    
    for i=1:numel(trials)
        trial = trials(i);
        correct = (trial.pseudoStim.correctKey == trial.responseKey);
        isReal = trial.pseudoStim.isReal;
        fileName = char(trial.pseudoStim.fileName);
        numTrials = numel(trials);
        if isReal;
        numReal = numReal+1;
        else
        numPseudo = numPseudo+1;
        end
        
        if strcmpi(phase,'study')
            if trial.pseudoStim.stimCount == 1
                numStudy1 = numStudy1 + 1;
                if isReal
                    numRealStudy1 = numRealStudy1 + 1;
                else
                    numPseudoStudy1 = numPseudoStudy1 + 1;
                end
            elseif trial.pseudoStim.stimCount == 2
                numStudy2 = numStudy2 + 1;
                if isReal
                    numRealStudy2 = numRealStudy2 + 1;
                else
                    numPseudoStudy2 = numPseudoStudy2 + 1;
                end
            end
        elseif strcmpi(phase,'test')
            if strcmpi(trial.pseudoStim.wordRelation,'study')
                numStudy = numStudy+1;
                if isReal
                    numRealStudy = numRealStudy + 1;
                else
                    numPseudoStudy = numPseudoStudy + 1;
                end
            elseif strcmpi(trial.pseudoStim.wordRelation,'ortho')
                numOrtho = numOrtho+1;
                if isReal
                    numRealOrtho = numRealOrtho + 1;
                else
                    numPseudoOrtho = numPseudoOrtho + 1;
                end
            elseif strcmpi(trial.pseudoStim.wordRelation,'novel')
                numNovel = numNovel+1;
                if isReal
                    numRealNovel = numRealNovel + 1;
                else
                    numPseudoNovel = numPseudoNovel + 1;
                end
            end
        end
        
        
        
        
        
        
        if trial.responseTime ~= 0
            numResponseTrials = numResponseTrials + 1;
            totalRTTrials = totalRTTrials + trial.responseTime;
            
            if strcmpi(phase,'test')
                if strcmpi(trial.pseudoStim.wordRelation,'study') 
                    numResponseStudy= numResponseStudy + 1;
                    totalRTStudy = totalRTStudy + trial.responseTime;
                    if isReal
                        numResponseReal = numResponseReal + 1;
                        totalRTReal = totalRTReal + trial.responseTime;
                        
                        numResponseRealStudy = numResponseRealStudy + 1;
                        totalRTRealStudy = totalRTRealStudy + trial.responseTime;
                    else
                        numResponsePseudo = numResponsePseudo + 1;
                        totalRTPseudo = totalRTPseudo + trial.responseTime;
                        
                        numResponsePseudoStudy = numResponsePseudoStudy + 1;
                        totalRTPseudoStudy = totalRTPseudoStudy + trial.responseTime;
                    end
            elseif strcmpi(trial.pseudoStim.wordRelation,'ortho')
                    numResponseOrtho = numResponseOrtho + 1;
                    totalRTOrtho = totalRTOrtho + trial.responseTime;
                    if isReal
                        numResponseReal = numResponseReal + 1;
                        totalRTReal = totalRTReal + trial.responseTime;
                        
                        numResponseRealOrtho = numResponseRealOrtho + 1;
                        totalRTRealOrtho = totalRTRealOrtho + trial.responseTime;
                    else
                        numResponsePseudo = numResponsePseudo + 1;
                        totalRTPseudo = totalRTPseudo + trial.responseTime;
                        
                        numResponsePseudoOrtho = numResponsePseudoOrtho + 1;
                        totalRTPseudoOrtho = totalRTPseudoOrtho + trial.responseTime;
                    end
           elseif strcmpi(trial.pseudoStim.wordRelation,'novel')
                    numResponseNovel= numResponseNovel + 1;
                    totalRTNovel = totalRTNovel + trial.responseTime;
                    if isReal
                        numResponseReal = numResponseReal + 1;
                        totalRTReal = totalRTReal + trial.responseTime;
                        
                        numResponseRealNovel = numResponseRealNovel + 1;
                        totalRTRealNovel = totalRTRealNovel + trial.responseTime;
                    else
                        numResponsePseudo = numResponsePseudo + 1;
                        totalRTPseudo = totalRTPseudo + trial.responseTime;
                        
                        numResponsePseudoNovel = numResponsePseudoNovel + 1;
                        totalRTPseudoNovel = totalRTPseudoNovel + trial.responseTime;
                    end
                end
         
            
            
            
            
            
            
            elseif strcmpi(phase,'study')
                if isReal
                    numResponseReal = numResponseReal + 1;
                    totalRTReal = totalRTReal + trial.responseTime; 
                    if trial.pseudoStim.stimCount == 1
                        numResponseRealStudy1 = numResponseRealStudy1 + 1;
                        totalRTRealStudy1 = totalRTRealStudy1 + trial.responseTime;
                        
                        numResponseStudy1 = numResponseStudy1 + 1;
                        totalRTStudy1 = totalRTStudy1 + trial.responseTime;
                    elseif trial.pseudoStim.stimCount == 2
                        numResponseRealStudy2 = numResponseRealStudy2 + 1;
                        totalRTRealStudy2 = totalRTRealStudy2 + trial.responseTime;
                        
                        numResponseStudy2 = numResponseStudy2 + 1;
                        totalRTStudy2 = totalRTStudy2 + trial.responseTime;
                    end
                else
                    numResponsePseudo = numResponsePseudo + 1;
                    totalRTPseudo = totalRTPseudo + trial.responseTime;
                    if trial.pseudoStim.stimCount == 1
                        numResponsePseudoStudy1 = numResponsePseudoStudy1 + 1;
                        totalRTPseudoStudy1 = totalRTPseudoStudy1 + trial.responseTime;
                        
                        numResponseStudy1 = numResponseStudy1 + 1;
                        totalRTStudy1 = totalRTStudy1 + trial.responseTime;
                    elseif trial.pseudoStim.stimCount == 2
                        numResponsePseudoStudy2 = numResponsePseudoStudy2 + 1;
                        totalRTPseudoStudy2 = totalRTPseudoStudy2 + trial.responseTime;
                        
                        numResponseStudy2 = numResponseStudy2 + 1;
                        totalRTStudy2 = totalRTStudy2 + trial.responseTime;
                    end
                end
            else
                if isReal
                    numResponseReal = numResponseReal + 1;
                    totalRTReal = totalRTReal + trial.responseTime; 
                else
                    numResponsePseudo = numResponsePseudo + 1;
                    totalRTPseudo = totalRTPseudo + trial.responseTime;
                end
                    
            end
            
    
            if correct
                correctTrials = correctTrials+1;
                correctRTTrials = correctRTTrials+trial.responseTime;
                if isReal
                    correctReal = correctReal+1;
                    correctRTReal = correctRTReal+trial.responseTime;
                    if strcmpi(phase,'study')
                        if trial.pseudoStim.stimCount == 1
                            correctRealStudy1 = correctRealStudy1 + 1;
                            correctRTRealStudy1 = correctRTRealStudy1 + trial.responseTime;
                            
                            correctStudy1 = correctStudy1 + 1;
                            correctRTStudy1 = correctRTStudy1 + trial.responseTime;
                        elseif trial.pseudoStim.stimCount == 2
                            correctRealStudy2 = correctRealStudy2 + 1;
                            correctRTRealStudy2 = correctRTRealStudy2 + trial.responseTime;
                            
                            correctStudy2 = correctStudy2 + 1;
                            correctRTStudy2 = correctRTStudy2 + trial.responseTime;
                        end
                    elseif strcmpi(phase,'test')
                        if strcmpi(trial.pseudoStim.wordRelation,'study')
                            correctStudy = correctStudy + 1;
                            correctRTStudy = correctRTStudy + trial.responseTime;
                            
                            correctRealStudy = correctRealStudy + 1;
                            correctRTRealStudy = correctRTRealStudy + trial.responseTime;
                        
                        elseif strcmpi(trial.pseudoStim.wordRelation,'ortho')
                            correctOrtho = correctOrtho + 1;
                            correctRTOrtho = correctRTOrtho + trial.responseTime;
                            
                            correctRealOrtho = correctRealOrtho + 1;
                            correctRTRealOrtho = correctRTRealOrtho + trial.responseTime;
                        
                        elseif strcmpi(trial.pseudoStim.wordRelation,'novel')
                            correctNovel = correctNovel + 1;
                            correctRTNovel = correctRTNovel + trial.responseTime;
                            
                            correctRealNovel = correctRealNovel + 1;
                            correctRTRealNovel = correctRTRealNovel + trial.responseTime;    
                        end
                    end
                else
                    correctPseudo = correctPseudo+1;
                    correctRTPseudo = correctRTPseudo + trial.responseTime;
                    if strcmpi(phase,'study')
                        if trial.pseudoStim.stimCount == 1
                            correctPseudoStudy1 = correctPseudoStudy1 + 1;
                            correctRTPseudoStudy1 = correctRTPseudoStudy1 + trial.responseTime;
                            
                            correctStudy1 = correctStudy1 + 1;
                            correctRTStudy1 = correctRTStudy1 + trial.responseTime;
                        elseif trial.pseudoStim.stimCount == 2
                            correctPseudoStudy2 = correctPseudoStudy2 + 1;
                            correctRTPseudoStudy2 = correctRTPseudoStudy2 + trial.responseTime;
                            
                            correctStudy2 = correctStudy2 + 1;
                            correctRTStudy2 = correctRTStudy2 + trial.responseTime;
                        end
                    elseif strcmpi(phase,'test')
                        if strcmpi(trial.pseudoStim.wordRelation,'study')
                            correctStudy = correctStudy + 1;
                            correctRTStudy = correctRTStudy + trial.responseTime;
                            
                            correctPseudoStudy = correctPseudoStudy + 1;
                            correctRTPseudoStudy = correctRTPseudoStudy + trial.responseTime;
                        
                        elseif strcmpi(trial.pseudoStim.wordRelation,'ortho')
                            correctOrtho = correctOrtho + 1;
                            correctRTOrtho = correctRTOrtho + trial.responseTime;
                            
                            correctPseudoOrtho = correctPseudoOrtho + 1;
                            correctRTSPseudoOrtho = correctRTPseudoOrtho + trial.responseTime;
                        
                        elseif strcmpi(trial.pseudoStim.wordRelation,'novel')
                            correctNovel = correctNovel + 1;
                            correctRTNovel = correctRTNovel + trial.responseTime;
                            
                            correctPseudoNovel = correctPseudoNovel + 1;
                            correctRTSPseudoNovel = correctRTPseudoNovel + trial.responseTime;    
                        end    
                    end
                end
            end
        end
      
        
        
    end
    
    accTrials = correctTrials/numTrials;
    avgRTTrials = totalRTTrials/numResponseTrials;
    avgCorrectRTTrials = correctRTTrials/correctTrials;
    
    accReal = correctReal/numReal;
    avgRTReal = totalRTReal/numResponseReal;
    avgCorrectRTReal = correctRTReal/correctReal;
    
    accPseudo = correctPseudo/numPseudo;
    avgRTPseudo = totalRTPseudo/numResponsePseudo;
    avgCorrectRTPseudo = correctRTPseudo/correctPseudo;
    
    
    if strcmpi(phase,'study')
        accStudy1 = correctStudy1/numStudy1;
        avgRTStudy1 = totalRTStudy1/numResponseStudy1;
        avgCorrectRTStudy1 = correctRTStudy1/correctStudy1;
        
        accRealStudy1 = correctRealStudy1/numRealStudy1;
        avgRTRealStudy1 = totalRTRealStudy1/numResponseRealStudy1;
        avgCorrectRTRealStudy1 = correctRTRealStudy1/correctRealStudy1;
    
        accPseudoStudy1 = correctPseudoStudy1/numPseudoStudy1;
        avgRTPseudoStudy1 = totalRTPseudoStudy1/numResponsePseudoStudy1;
        avgCorrectRTPseudoStudy1 = correctRTPseudoStudy1/correctPseudoStudy1;
    
        accStudy2 = correctStudy2/numStudy2;
        avgRTStudy2 = totalRTStudy2/numResponseStudy2;
        avgCorrectRTStudy2 = correctRTStudy2/correctStudy2;
        
        accRealStudy2 = correctRealStudy2/numRealStudy2;
        avgRTRealStudy2 = totalRTRealStudy2/numResponseRealStudy2;
        avgCorrectRTRealStudy2 = correctRTRealStudy2/correctRealStudy2;
    
        accPseudoStudy2 = correctPseudoStudy2/numPseudoStudy2;
        avgRTPseudoStudy2 = totalRTPseudoStudy2/numResponsePseudoStudy2;
        avgCorrectRTPseudoStudy2 = correctRTPseudoStudy2/correctPseudoStudy2;
        
        fprintf(fid,'ACCURACY\n');
        fprintf(fid,'AllTrialsAcc\tRealAcc\tPseudoAcc\tStudy1Acc\tStudy1RealAcc\tStudy1PseudoAcc\tStudy2Acc\tStudy2RealAcc\tStudy2PseudoAcc\n');
        fprintf(fid,'%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\n',accTrials,accReal,accPseudo,accStudy1,accRealStudy1,accPseudoStudy1,accStudy2, accRealStudy2,accPseudoStudy2);
        
        fprintf(fid,'RT ALL TRIALS\n');
        fprintf(fid,'AllTrialsRT\tRealRT\tPseudoRT\tStudy1RT\tStudy1RealRT\tStudy1PseudoRT\tStudy2RT\tStudy2RealRT\tStudy2PseudoRT\n');
        fprintf(fid,'%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\n',avgRTTrials,avgRTReal,avgRTPseudo,avgRTStudy1,avgRTRealStudy1,avgRTPseudoStudy1,avgRTStudy2, avgRTRealStudy2,avgRTPseudoStudy2);
    
        fprintf(fid,'RT CORRECT TRIALS\n');
        fprintf(fid,'AllTrialsRT\tRealRT\tPseudoRT\tStudy1RT\tStudy1RealRT\tStudy1PseudoRT\tStudy2RT\tStudy2RealRT\tStudy2PseudoRT\n');
        fprintf(fid,'%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\n',avgCorrectRTTrials,avgCorrectRTReal,avgCorrectRTPseudo,avgCorrectRTStudy1,avgCorrectRTRealStudy1,avgCorrectRTPseudoStudy1,avgCorrectRTStudy2, avgCorrectRTRealStudy2,avgCorrectRTPseudoStudy2);
    
    elseif strcmpi(phase,'test')
        accStudy = correctStudy/numStudy;
        avgRTStudy = totalRTStudy/numResponseStudy;
        avgCorrectRTStudy = correctRTStudy/correctStudy;
        
        accRealStudy = correctRealStudy/numRealStudy;
        avgRTRealStudy = totalRTRealStudy/numResponseRealStudy;
        avgCorrectRTRealStudy = correctRTRealStudy/correctRealStudy;
    
        accPseudoStudy = correctPseudoStudy/numPseudoStudy;
        avgRTPseudoStudy = totalRTPseudoStudy/numResponsePseudoStudy;
        avgCorrectRTPseudoStudy = correctRTPseudoStudy/correctPseudoStudy;
    
        accOrtho = correctOrtho/numOrtho;
        avgRTOrtho = totalRTOrtho/numResponseOrtho;
        avgCorrectRTOrtho = correctRTOrtho/correctOrtho;
        
        accRealOrtho = correctRealOrtho/numRealOrtho;
        avgRTRealOrtho = totalRTRealOrtho/numResponseRealOrtho;
        avgCorrectRTRealOrtho = correctRTRealOrtho/correctRealOrtho;
    
        accPseudoOrtho = correctPseudoOrtho/numPseudoOrtho;
        avgRTPseudoOrtho = totalRTPseudoOrtho/numResponsePseudoOrtho;
        avgCorrectRTPseudoOrtho = correctRTPseudoOrtho/correctPseudoOrtho;
        
        accNovel = correctNovel/numNovel;
        avgRTNovel = totalRTNovel/numResponseNovel;
        avgCorrectRTNovel = correctRTNovel/correctNovel;
        
        accRealNovel = correctRealNovel/numRealNovel;
        avgRTRealNovel = totalRTRealNovel/numResponseRealNovel;
        avgCorrectRTRealNovel = correctRTRealNovel/correctRealNovel;
    
        accPseudoNovel = correctPseudoNovel/numPseudoNovel;
        avgRTPseudoNovel = totalRTPseudoNovel/numResponsePseudoNovel;
        avgCorrectRTPseudoNovel = correctRTPseudoNovel/correctPseudoNovel;
        
        fprintf(fid,'ACCURACY\n');
        fprintf(fid,'AllTrialsAcc\tRealAcc\tPseudoAcc\tStudyAcc\tStudyRealAcc\tStudy1seudoAcc\tOrthoAcc\tOrthRealAcc\tOrthoPseudoAcc\tNovelAcc\tNovelRealAcc\tNovelPseudoAcc\n');
        fprintf(fid,'%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\n',accTrials,accReal,accPseudo,accStudy,accRealStudy,accPseudoStudy,accOrtho, accRealOrtho,accPseudoOrtho,accNovel,accRealNovel,accPseudoNovel);
    
        
        fprintf(fid,'RT ALL TRIALS\n');
        fprintf(fid,'AllTrialsRT\tRealRT\tPseudoRT\tStudyRT\tStudyRealRT\tStudy1seudoRT\tOrthoRT\tOrthRealRT\tOrthoPseudoRT\tNovelRT\tNovelRealRT\tNovelPseudoRT\n');
        fprintf(fid,'%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\n',avgRTTrials,avgRTReal,avgRTPseudo,avgRTStudy,avgRTRealStudy,avgRTPseudoStudy,avgRTOrtho, avgRTRealOrtho,avgRTPseudoOrtho,avgRTNovel,avgRTRealNovel,avgRTPseudoNovel);
        
        fprintf(fid,'RT CORRECT TRIALS\n');
        fprintf(fid,'AllTrialsRT\tRealRT\tPseudoRT\tStudyRT\tStudyRealRT\tStudy1seudoRT\tOrthoRT\tOrthRealRT\tOrthoPseudoRT\tNovelRT\tNovelRealRT\tNovelPseudoRT\n');
        fprintf(fid,'%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\n',avgCorrectRTTrials,avgCorrectRTReal,avgCorrectRTPseudo,avgCorrectRTStudy,avgCorrectRTRealStudy,avgCorrectRTPseudoStudy,avgCorrectRTOrtho, avgCorrectRTRealOrtho,avgCorrectRTPseudoOrtho,avgCorrectRTNovel,avgCorrectRTRealNovel,avgCorrectRTPseudoNovel);
    else   
        fprintf(fid,'ACCURACY\n');
        fprintf(fid,'AllTrialsAcc\tRealAcc\tPseudoAcc\n');
        fprintf(fid,'%1.4f\t%1.4f\t%1.4f\n',accTrials,accReal,accPseudo);
    
        
        fprintf(fid,'RT ALL TRIALS\n');
        fprintf(fid,'AllTrialsRT\tRealRT\tPseudoRT\n');
        fprintf(fid,'%1.4f\t%1.4f\t%1.4f\n',avgRTTrials,avgRTReal,avgRTPseudo);
        
        fprintf(fid,'RT CORRECT TRIALS\n');
        fprintf(fid,'AllTrialsRT\tRealRT\tPseudoRT\n');
        fprintf(fid,'%1.4f\t%1.4f\t%1.4f\n',avgCorrectRTTrials,avgCorrectRTReal,avgCorrectRTPseudo);
    end
    
    
    
    if numel(trialsAnalyzed) ~= 0
        
        for i=1:numel(trialsAnalyzed)
            trial = trialsAnalyzed(i);
            isReal = trial.pseudoStim.isReal;
            consistentTrials = numel(trialsAnalyzed);
            consistentRTTrials = consistentRTTrials + trial.responseTime;
            if strcmpi(phase,'test')
                if strcmpi(trial.pseudoStim.wordRelation,'study') 
                   
                    consistentStudy = consistentStudy + 1;
                    consistentRTStudy = consistentRTStudy + trial.responseTime;
                    if isReal
                        consistentRealStudy = consistentRealStudy+1;
                        consistentRTRealStudy = consistentRTRealStudy + trial.responseTime;
                    else
                        consistentPseudoStudy = consistentPseudoStudy+1;
                        consistentRTPseudoStudy = consistentRTPseudoStudy + trial.responseTime;
                    end
                end
            end

            if strcmpi(phase,'study')
                if trial.pseudoStim.stimCount == 1
                    consistentStudy1 = consistentStudy1 + 1;
                    consistentRTStudy1 = consistentRTStudy1 + trial.responseTime;
                    if isReal
                        consistentReal = consistentReal + 1;
                        consistentRTReal = consistentRTReal + trial.responseTime;

                        consistentRealStudy1 = consistentRealStudy1 + 1;
                        consistentRTRealStudy1 = consistentRTRealStudy1 + trial.responseTime;
                    else
                        consistentPseudo = consistentPseudo + 1;
                        consistentRTPseudo = consistentRTPseudo + trial.responseTime;

                        consistentPseudoStudy1 = consistentPseudoStudy1 + 1;
                        consistentRTPseudoStudy1 = consistentRTPseudoStudy1 + trial.responseTime;
                    end
                elseif trial.pseudoStim.stimCount == 2
                    consistentStudy2 = consistentStudy2 + 1;
                    consistentRTStudy2 = consistentRTStudy2 + trial.responseTime;
                    if isReal
                        consistentReal = consistentReal + 1;
                        consistentRTReal = consistentRTReal + trial.responseTime;

                        consistentRealStudy2 = consistentRealStudy2 + 1;
                        consistentRTRealStudy2 = consistentRTRealStudy2 + trial.responseTime;
                    else
                        consistentPseudo = consistentPseudo + 1;
                        consistentRTPseudo = consistentRTPseudo + trial.responseTime;

                        consistentPseudoStudy2 = consistentPseudoStudy2 + 1;
                        consistentRTPseudoStudy2 = consistentRTPseudoStudy2 + trial.responseTime;
                    end
                end
            end 



        end
        avgConsistentRTTrials = consistentRTTrials/consistentTrials;

        avgConsistentRTReal = consistentRTReal/consistentReal;

        avgConsistentRTPseudo = consistentRTPseudo/consistentPseudo;

        if strcmpi(phase,'study')

            avgConsistentRTStudy1 = consistentRTStudy1/consistentStudy1;

            avgConsistentRTRealStudy1 = consistentRTRealStudy1/consistentRealStudy1;

            avgConsistentRTPseudoStudy1 = consistentRTPseudoStudy1/consistentPseudoStudy1;

            avgConsistentRTStudy2 = consistentRTStudy2/consistentStudy2;

            avgConsistentRTRealStudy2 = consistentRTRealStudy2/consistentRealStudy2;

            avgConsistentRTPseudoStudy2 = consistentRTPseudoStudy2/consistentPseudoStudy2;

            fprintf(fid,'RT CONSISTENT TRIALS\n');
            fprintf(fid,'AllTrialsRT\tRealRT\tPseudoRT\tStudy1RT\tStudy1RealRT\tStudy1PseudoRT\tStudy2RT\tStudy2RealRT\tStudy2PseudoRT\n');
            fprintf(fid,'%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\n',avgConsistentRTTrials,avgConsistentRTReal,avgConsistentRTPseudo,avgConsistentRTStudy1,avgConsistentRTRealStudy1,avgConsistentRTPseudoStudy1,avgConsistentRTStudy2, avgConsistentRTRealStudy2,avgConsistentRTPseudoStudy2);
        elseif strcmpi(phase,'test')
            
            avgConsistentRTStudy = consistentRTStudy/consistentStudy;

            avgConsistentRTRealStudy = consistentRTRealStudy/consistentRealStudy;

            avgConsistentRTPseudoStudy = consistentRTPseudoStudy/consistentPseudoStudy;
            
            fprintf(fid,'RT CONSISTENT TRIALS\n');
            fprintf(fid,'StudyRT\tStudyRealRT\tStudyPseudoRT\n');
            fprintf(fid,'%1.4f\t%1.4f\t%1.4f\n',avgConsistentRTStudy,avgConsistentRTRealStudy,avgConsistentRTPseudoStudy);
        end
    else
        if strcmpi(phase,'study')
            fprintf(fid,'RT CONSISTENT TRIALS\n');
            fprintf(fid,'AllTrialsRT\tRealRT\tPseudoRT\tStudy1RT\tStudy1RealRT\tStudy1PseudoRT\tStudy2RT\tStudy2RealRT\tStudy2PseudoRT\n');
            fprintf(fid,'%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\n', NaN(1), NaN(1), NaN(1), NaN(1), NaN(1), NaN(1), NaN(1), NaN(1), NaN(1));

        elseif strcmpi(phase,'test')
            fprintf(fid,'RT CONSISTENT TRIALS\n');
            fprintf(fid,'StudyRT\tStudyRealRT\tStudyPseudoRT\n');
            fprintf(fid,'%1.4f\t%1.4f\t%1.4f\n',NaN(1), NaN(1), NaN(1));
        
        else
            fprintf(fid,'RT CONSISTENT TRIALS\n');
            fprintf(fid,'AllTrialRT\tRealRT\tPseudoRT\n');
            fprintf(fid,'%1.4f\t%1.4f\t%1.4f\n',NaN(1), NaN(1), NaN(1));
        end    
    end
end