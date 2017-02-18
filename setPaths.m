function [stimPath, legPath, optseqFilepath, wordBlock] = setPaths( block, subcode, session, phase)
    
    rand_int = randi([1 200]);
    % determine random int to call random optseq file
    if strcmpi(phase, 'test')
        disp('YAY');
        %file to track which optseq numbers already used
        fidOptseqNumbers = fopen('optseqlog','r');
        pastOptseqNumbers = [];
        while ~feof(fidOptseqNumbers) 
            disp('YAYO');
            pastOptseqNumbers = [pastOptseqNumbers fgetl(fidOptseqNumbers)];
        end

        % check to see if rand_int is valid or not
        flag = 0;
        while flag == 1
            rand_int = randi([1 200]);
            for i=1:length(pastOptseqNumbers)
                if rand_int == pastOptseqNumbers(i)
                    flag = 1;
                end
            end
        end
        fclose(fidOptseqNumbers);
        fidOptseqNumbers = fopen('optseqlog','a');
        fprintf(fidOptseqNumbers, '%d\n', rand_int);
        fclose(fidOptseqNumbers);
    end
    
    rand_int = sprintf('%03d', rand_int);
    switch block
        case 'Word'
            stimPath = 'Stimuli/Words/';
            legPath = strcat('Legends/',subcode,'/session',int2str(session),'/',lower(phase),'/word.');
            optseqFilepath = strcat('optseq/Words-',rand_int,'.par');
            wordBlock = 1;
        case 'Word1'
            stimPath = 'Stimuli/Words/';
            legPath = strcat('Legends/',subcode,'/session',int2str(session),'/',lower(phase),'/word1.');
            optseqFilepath = strcat('optseq/Words-',rand_int,'.par');
            wordBlock = 1;
        case 'Word2'
            stimPath = 'Stimuli/Words/';
            legPath = strcat('Legends/',subcode,'/session',int2str(session),'/',lower(phase),'/word2.');
            optseqFilepath = strcat('optseq/Words-',rand_int,'.par');
            wordBlock = 1;
        case 'Face'
            stimPath = 'Stimuli/Faces/';
            legPath = strcat('Legends/',subcode,'/session',int2str(session),'/',lower(phase),'/face.');
            optseqFilepath = strcat('optseq/ObjsFaces-',rand_int,'.par');
            wordBlock = 0;
        case 'Object'
            stimPath = 'Stimuli/Objects/';
            legPath = strcat('Legends/',subcode,'/session',int2str(session),'/',lower(phase),'/object.');
            optseqFilepath = strcat('optseq/ObjsFaces-',rand_int,'.par');
            wordBlock = 0;
        otherwise
            error('Unexpected block type.');
    end

end
