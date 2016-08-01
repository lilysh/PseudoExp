function printData(trials, phase,fileName,consistentStims,inconsistentStims,studyStims)    
    
    fid=fopen(fileName, 'a');
    
    
    numOrtho = 0;
    numRealOrtho = 0;
    numPseudoOrtho = 0;
    numResponseOrtho = 0;
    numResponseRealOrtho = 0;
    numResponsePseudoOrtho = 0;
    totalRTOrtho = 0;
    totalRTRealOrtho = 0;
    totalRTPseudoOrtho = 0;
    correctOrtho = 0;
    correctRealOrtho = 0;
    correctPseudoOrtho = 0;
    correctRTOrtho = 0;
    correctRTRealOrtho = 0;
    correctRTPseudoOrtho = 0;
    
    
    
    
    numNovel = 0;
    numRealNovel = 0;
    numPseudoNovel = 0;
    numResponseNovel = 0;
    numResponseRealNovel = 0;
    numResponsePseudoNovel = 0;
    totalRTNovel = 0;
    totalRTRealNovel = 0;
    totalRTPseudoNovel = 0;
    correctNovel = 0;
    correctRealNovel = 0;
    correctPseudoNovel = 0;
    correctRTNovel = 0;
    correctRTRealNovel = 0;
    correctRTPseudoNovel = 0;
    
    
    numStudy = 0;
    numRealStudy = 0;
    numPseudoStudy = 0;
    numResponseStudy = 0;
    numResponseRealStudy = 0;
    numResponsePseudoStudy = 0;
    totalRTStudy = 0;
    totalRTRealStudy = 0;
    totalRTPseudoStudy = 0;
    correctStudy = 0;
    correctRealStudy = 0;
    correctPseudoStudy = 0;
    correctRTStudy = 0;
    correctRTRealStudy = 0;
    correctRTPseudoStudy = 0;
    
    numResponseRealStudy1 = 0;
    numResponseRealStudy2 = 0;
    numResponsePseudoStudy1 = 0;
    numResponsePseudoStudy2 = 0;
    
    correctRealStudy1 = 0;
    correctRealStudy2 = 0;
    correctPseudoStudy1 = 0;
    correctPseudoStudy2 = 0;
    
    correctRealRTStudy1 = 0;
    correctRealRTStudy2 = 0;
    correctPseudoRTStudy1 = 0;
    correctPseudoRTStudy2 = 0;
    
    totalRTStudy1 = 0;
    totalRealRTStudy1 = 0;
    totalPseudoRTStudy1 = 0;
    totalRTStudy2 = 0;
    totalRealRTStudy2 = 0;
    totalPseudoRTStudy2 = 0;
    
    numStudy1 = 0;
    numStudy2 = 0;
    numRealStudy1 = 0;
    numPseudoStudy1 = 0;
    numRealStudy2 = 0;
    numPseudoStudy2 = 0; 
    numResponseStudy1 = 0;
    numResponseStudy2 = 0;
    correctStudy1 = 0;
    correctStudy2 = 0;
    correctRTStudy1 = 0;
    correctRTStudy2 = 0;
    
    numResponses = 0;
    totalAcc = 0;
    totalRT = 0;
    correctRT = 0;
    
    numReal = 0;
    numCorrectReal = 0;
    correctRealRT = 0;
    
    numPseudo = 0;
    numCorrectPseudo = 0;
    correctPseudoRT = 0;
    
    studyStim = 0;
    studyCorrect = 0;
    studyCorrectRT = 0;
    
    orthoStim = 0;
    orthoCorrect = 0;
    orthoCorrectRT = 0;
    
    novelStim = 0;
    novelCorrect = 0;
    novelCorrectRT = 0;
    
    realStudyStim = 0;
    realStudyCorrect = 0;
    realStudyCorrectRT = 0;
    
    pseudoStudyStim = 0;
    pseudoStudyCorrect = 0;
    pseudoStudyCorrectRT = 0;
    
    realOrthoStim = 0;
    realOrthoCorrect = 0;
    realOrthoCorrectRT = 0;
    
    pseudoOrthoStim = 0;
    pseudoOrthoCorrect = 0;
    pseudoOrthoCorrectRT = 0;
    
    realNovelStim = 0;
    realNovelCorrect = 0;
    realNovelCorrectRT = 0;
    
    pseudoNovelStim = 0;
    pseudoNovelCorrect = 0;
    pseudoNovelCorrectRT = 0;
    
    stimsC={};
    stimsI={};
    response={};
    countT = 0;
    countC = 0;
    countI = 0;
    if strcmpi(phase,'study')
        fidC=fopen(consistentStims,'w');
        fidI=fopen(inconsistentStims,'w');
        for i = 1:numel(trials)
            for j = 1:numel(trials)
                if i~=j
                    if strcmpi(trials(i).pseudoStim.stimID,trials(j).pseudoStim.stimID)
                        if trials(i).responseTime ~= 0
                            if (trials(i).responseKey==trials(j).responseKey)   
                                countT = countT + 1;
                                trialsAnalyzed(countT) = trials(i);
                                if ~any(ismember(stimsC,trials(i).pseudoStim.stimID))
                                    countC = countC+1;
                                    stimsC{countC} = trials(i).pseudoStim.stimID;
                                    response{countC} = trials(i).responseType;
                                end
                            else
                                if ~any(ismember(stimsI,trials(i).pseudoStim.stimID))
                                    countI = countI+1;
                                    stimsI{countI} = trials(i).pseudoStim.stimID;
                                end
                            end
                        else
                            if ~any(ismember(stimsI,trials(i).pseudoStim.stimID))
                                countI = countI+1;
                                stimsI{countI} = trials(i).pseudoStim.stimID;
                            end
                        end
                    end
                end
            end
        end
    elseif strcmpi(phase,'test')
        fidC=fopen(consistentStims,'w');
        fidI=fopen(inconsistentStims,'w');
        fidS = fopen(studyStims,'r');
        countS= 1;
        line = fgetl(fidS);
        while ischar(line)
            stimS=strsplit(line,'\t');
            for i = 1:numel(trials)
                if strcmpi(trials(i).pseudoStim.stimID, stimS{1})
                    if strcmpi(trials(i).responseType, stimS{2})
                        countT = countT + 1;
                        trialsAnalyzed(countT) = trials(i);
                        if ~any(ismember(stimsC,trials(i).pseudoStim.stimID))
                            countC = countC + 1
                            stimsC{countC} = trials(i).pseudoStim.stimID;
                        end
                    end
                end
            end
            line = fgetl(fidS);
        end
        stimsC
        for i =1:numel(trials)
            if strcmpi(trials(i).pseudoStim.wordRelation,'novel')
                countT = countT + 1;
                trialsAnalyzed(countT) = trials(i);
                countC = countC + 1
                stimsC{countC} = trials(i).pseudoStim.stimID;
            elseif strcmpi(trials(i).pseudoStim.wordRelation,'ortho')
                countT = countT + 1;
                trialsAnalyzed(countT) = trials(i);
                countC = countC + 1
                stimsC{countC} = trials(i).pseudoStim.stimID;
            end
        end
    else
        trialsAnalyzed = trials;
    end
    stimsC
    if numel(stimsC) > 0
        for i = 1:numel(stimsC)
            if strcmpi(phase,'study')
                fprintf(fidC,'%s\t%s\n',stimsC{i},response{i});
            else
                fprintf(fidC,'%s\n',stimsC{i});
            end
        end
    end
    
    if numel(stimsI) > 0
        for i = 1:numel(stimsI)
            fprintf(fidI,'%s\n',stimsI{i});
        end
    end
    
    for i=1:numel(trials)
        trial = trials(i);
        correct = (trial.pseudoStim.correctKey == trial.responseKey);
        isReal = trial.pseudoStim.isReal;
        fileName = char(trial.pseudoStim.fileName);
        if isReal;
        numReal = numReal+1;
        else
        numPseudo = numPseudo+1;
        end
        if correct
            totalAcc = totalAcc+1;
            correctRT = correctRT+trial.responseTime;
            if isReal
                numCorrectReal = numCorrectReal+1;
                correctRealRT = correctRealRT+trial.responseTime;
            else
                numCorrectPseudo = numCorrectPseudo+1;
                correctPseudoRT = correctPseudoRT+trial.responseTime;
            end
            
        end
        fprintf(fid,'%d\t%3.2f\t%1.4f\t%1.4f\t%3.4f\t%c\t%1.4f\t%d\t%d\t%s\n',i,trial.onsetTime,trial.stimDur,trial.maskDur,trial.fixDur,trial.responseKey,trial.responseTime,correct,char(trial.pseudoStim.stimCount),fileName);

    end
    for i=1:numel(trialsAnalyzed)
        trial = trialsAnalyzed(i);
        isReal = trial.pseudoStim.isReal;
        correct = (trial.pseudoStim.correctKey == trial.responseKey);
        
        if strcmpi(phase,'test')
            if strcmpi(trial.pseudoStim.wordRelation,'study') 
                trial.pseudoStim.stimCount = 3;
                numStudy = numStudy + 1;
                if isReal
                    numRealStudy = numRealStudy+1;
                else
                    numPseudoStudy = numPseudoStudy+1;
                end
            elseif strcmpi(trial.pseudoStim.wordRelation,'novel')
                trial.pseudoStim.stimCount = 1;
                numNovel = numNovel+1;
                if isReal
                    numRealNovel = numRealNovel + 1;
                else
                    numPseudoNovel = numPseudoNovel + 1;
                end
            elseif strcmpi(trial.pseudoStim.wordRelation,'ortho')
                trial.pseudoStim.stimCount = 0;
                numOrtho = numOrtho + 1;
                if isReal
                    numRealOrtho = numRealOrtho + 1;
                else
                    numPseudoOrtho = numPseudoOrtho + 1;
                end
            end
        end
        
        if strcmpi(phase,'study')
            if trial.pseudoStim.stimCount == 1
                numStudy1 = numStudy1 + 1;
                totalRTStudy1 = totalRTStudy1 + trial.pseudoStim.responseTime;
                if isReal
                    numRealStudy1 = numRealStudy1 + 1;
                    totalRealRTStudy1 = totalRealRTStudy1 + trial.pseudoStim.responseTime;
                else
                    numPseudoStudy1 = numPseudoStudy1 + 1;
                    totalPseudoRTStudy1 = totalPseudoRTStudy1 + trial.pseudoStim.responseTime;
                end
            elseif trial.pseudoStim.stimCount == 2
                numStudy2 = numStudy2 + 1;
                totalRTStudy2 = totalRTStudy2 + trial.pseudoStim.responseTime;
                if isReal
                    numRealStudy2 = numRealStudy2 + 1;
                    totalRealRTStudy2 = totalRealRTStudy2 + trial.pseudoStim.responseTime;
                else
                    numPseudoStudy2 = numPseudoStudy2 + 1;
                    totalPseudoRTStudy1 = totalPseudoRTStudy1 + trial.pseudoStim.responseTime;
                end
            end
        end 
        
        if trial.responseTime ~= 0
        
        
            if strcmpi(phase,'test')
                if strcmpi(trial.pseudoStim.wordRelation,'study') 
                    numResponseStudy= numResponseStudy + 1;
                    totalRTStudy = totalRTStudy + trial.responseTime;
                    if isReal
                        realStudyStim = realStudyStim+1;
                    else
                        pseudoStudyStim = pseudoStudyStim+1;
                    end
                elseif strcmpi(trial.pseudoStim.wordRelation,'novel')
                    trial.pseudoStim.stimCount = 1;
                    novelStim = novelStim+1;
                    if isReal
                        realNovelStim = realNovelStim+1;
                    else
                        pseudoNovelStim = pseudoNovelStim+1;
                    end
                elseif strcmpi(trial.pseudoStim.wordRelation,'ortho')
                    trial.pseudoStim.stimCount = 0;
                    orthoStim = orthoStim+1;
                    if isReal
                        realOrthoStim = realOrthoStim+1;
                    else
                        pseudoOrthoStim = pseudoOrthoStim+1;
                    end
                end
            end
            
            
            
            
            
            
            if strcmpi(phase,'study')
                if isReal
                    if trial.pseudoStim.stimCount == 1
                        numResponseRealStudy1 = numResponseRealStudy1 + 1;
                        numResponseStudy1 = numResponseStudy1 + 1;
                    elseif trial.pseudoStim.stimCount == 2
                        numResponseRealStudy2 = numResponseRealStudy2 + 1;
                        numResponseStudy2 = numResponseStudy2 + 1;
                    end
                else
                    if trial.pseudoStim.stimCount == 1
                        numResponsePseudoStudy1 = numResponsePseudoStudy1 + 1;
                        numResponseStudy1 = numResponseStudy1 + 1;
                    elseif trial.pseudoStim.stimCount == 2
                        numResponsePseudoStudy2 = numResponsePseudoStudy2 + 1;
                        numResponseStudy2 = numResponseStudy1 + 2;
                    end
                end
            end
            
    
            if correct
                if isReal
                    if strcmpi(phase,'study')
                        if trial.pseudoStim.stimCount == 1
                            correctRealStudy1 = correctRealStudy1 + 1;
                            correctRealRTStudy1 = correctRealRTStudy1 + trial.responseTime;
                            
                            correctStudy1 = correctStudy1 + 1;
                            correctRTStudy1 = correctRTStudy1 + trial.responseTime;
                        elseif trial.pseudoStim.stimCount == 2
                            correctRealStudy2 = correctRealStudy2 + 1;
                            correctRealRTStudy2 = correctRealRTStudy2 + trial.responseTime;
                            
                            correctStudy2 = correctStudy2 + 1;
                            correctRTStudy2 = correctRTStudy2 + trial.responseTime;
                        end
                    end
                else
                    if strcmpi(phase,'study')
                        if trial.pseudoStim.stimCount == 1
                            correctPseudoStudy1 = correctPseudoStudy1 + 1;
                            correctPseudoRTStudy1 = correctPseudoRTStudy1 + trial.responseTime;
                            
                            correctStudy1 = correctStudy1 + 1;
                            correctRTStudy1 = correctRTStudy1 + trial.responseTime;
                        elseif trial.pseudoStim.stimCount == 2
                            correctPseudoStudy2 = correctPseudoStudy2 + 1;
                            correctPseudoRTStudy2 = correctPseudoRTStudy2 + trial.responseTime;
                            
                            correctStudy2 = correctStudy2 + 1;
                            correctRTStudy2 = correctRTStudy2 + trial.responseTime;
                        end
                    end                    
                end
            end
        end
        
    end
    fprintf(fid,'RealACC\tPseudoACC\tAllACC\t\n');
    allAcc = (totalAcc/(numel(trials)))*100;
    realAcc = (numCorrectReal/numReal)*100;
    pseudoAcc = (numCorrectPseudo/numPseudo)*100;
    fprintf(fid,'%1.4f\t%1.4f\t%1.4f\t\n',realAcc,pseudoAcc,allAcc);
    
    fprintf(fid,'RealCorRT\tPseudoCorRT\tAllCorRT\t\n');
    
    if totalAcc == 0 
       avgCorrectRT = 0;
    else
       avgCorrectRT = (correctRT/totalAcc);        % average latency on correct trials
    end
    
    if numCorrectReal == 0
        avgCorrectRealRT = 0;
    else
        avgCorrectRealRT = (correctRealRT/numCorrectReal);  % average latency for correct real stimuli
    end
    
    if numCorrectPseudo == 0 
       avgCorrectPseudoRT = 0;
    else
       avgCorrectPseudoRT = (correctPseudoRT/numCorrectPseudo);    % average latency for correct pseudo stimuli    
    end
    
    fprintf(fid,'%1.4f\t%1.4f\t%1.4f\t',avgCorrectRealRT,avgCorrectPseudoRT,avgCorrectRT);
    if strcmpi(phase,'study')
        fprintf(fid,'\n\n');
        study1Acc = (correctStudy1/numStudy1);
        if correctStudy1 == 0 
            avgCorrectRTStudy1 = 0;
        else
            avgCorrectRTStudy1 = (correctRTStudy1/correctStudy1);
        end
        
        study2Acc = (correctStudy2/numStudy2);
        if correctStudy2 == 0 
            avgCorrectRTStudy2 = 0;
        else
            avgCorrectRTStudy2 = (correctRTStudy2/correctStudy2);
        end
        
        study1RealAcc = (correctRealStudy1/numRealStudy1);
        if correctRealStudy1 == 0 
            avgCorrectRealRTStudy1 = 0;
        else
            avgCorrectRealRTStudy1 = (correctRealRTStudy1/correctRealStudy1);
        end
        
        study2RealAcc = (correctRealStudy2/numRealStudy2);
        if correctRealStudy2 == 0 
            avgCorrectRealRTStudy2 = 0;
        else
            avgCorrectRealRTStudy2 = (correctRealRTStudy2/correctRealStudy2);
        end
        
        
        study1PseudoAcc = (correctPseudoStudy1/numPseudoStudy1);
        if correctPseudoStudy1 == 0 
            avgCorrectPseudoRTStudy1 = 0;
        else
            avgCorrectPseudoRTStudy1 = (correctPseudoRTStudy1/correctPseudoStudy1);
        end
        
        study2PseudoAcc = (correctPseudoStudy2/numPseudoStudy2);
        if correctPseudoStudy2 == 0 
            avgCorrectPseudoRTStudy2 = 0;
        else
            avgCorrectPseudoRTStudy2 = (correctPseudoRTStudy2/correctPseudoStudy2);
        end
        fprintf(fid,'Correct Trials:\n');
        fprintf(fid,'Study1Acc\tStudy1RT\tStudy2Acc\tStudy2RT\n');
        fprintf(fid,'%1.4f\t%1.4f\t%1.4f\t%1.4f\n\n',study1Acc,avgCorrectRTStudy1,study2Acc,avgCorrectRTStudy2);
        fprintf(fid,'Study1RealAcc\tStudy1RealRT\tStudy2RealAcc\tStudy2RealRT\n');
        fprintf(fid,'%1.4f\t%1.4f\t%1.4f\t%1.4f\n\n',study1RealAcc, avgCorrectRealRTStudy1, study2RealAcc, avgCorrectRealRTStudy2);
        fprintf(fid,'Study1PseudoAcc\tStudy1PseudoRT\tStudy2PseudoAcc\tStudy2PseudoRT\n');
        fprintf(fid,'%1.4f\t%1.4f\t%1.4f\t%1.4f\n', study1PseudoAcc, avgCorrectPseudoRTStudy1,study2PseudoAcc,avgCorrectPseudoRTStudy2);
    end
end