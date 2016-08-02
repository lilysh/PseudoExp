function [stimPath, legPath, wordBlock] = setPaths( block, subcode, session, phase)

    switch block
        case 'Word'
            stimPath = 'Stimuli/Words/';
            legPath = strcat('Legends/',subcode,'/session',int2str(session),'/',lower(phase),'/word.');
            wordBlock = 1;
        case 'Word1'
            stimPath = 'Stimuli/Words/';
            legPath = strcat('Legends/',subcode,'/session',int2str(session),'/',lower(phase),'/word1.');
            wordBlock = 1;
        case 'Word2'
            stimPath = 'Stimuli/Words/';
            legPath = strcat('Legends/',subcode,'/session',int2str(session),'/',lower(phase),'/word2.');
            wordBlock = 1;
        case 'Face'
            stimPath = 'Stimuli/Faces/';
            legPath = strcat('Legends/',subcode,'/session',int2str(session),'/',lower(phase),'/face.');
            wordBlock = 0;
        case 'Object'
            stimPath = 'Stimuli/Objects/';
            legPath = strcat('Legends/',subcode,'/session',int2str(session),'/',lower(phase),'/object.');
            wordBlock = 0;
        otherwise
            error('Unexpected block type.');
    end

end
