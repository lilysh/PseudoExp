function ps = pseudoStimTest( thisMeta, filename, reudo )
         ps = struct ('metaData','',...
                      'stimulus',0,...
                      'stimCount',1,...
                      'sequence',0,...
                      'fwdPointer',0,...
                      'correctKey','',...
                      'fileName','',...
                      'blockType','',...
                      'stimID','',...
                      'orthoNeighbor','',...
                      'isReal','',...
                      'stimType','',...
                      'phase','',...
                      'wordRelation','' ...
                         );
     if ~(isempty(thisMeta))
        ps.metaData = thisMeta;
        md = regexp(ps.metaData,',','split');
        %fprintf('md: %s\n', ps.metaData);
        ps.blockType = md(1);
        ps.phase = lower(char(md(2)));
        ps.fileName = filename;
        if strcmp( reudo, 'real')
            ps.isReal = 1;
            ps.stimType = 'real';
        elseif strcmp( reudo, 'pseudo')
            ps.isReal = 0;
        elseif strcmp( reudo, 'null')
            ps.isReal = 0;
        else
            error('metadata for this experiment is invalid');
        end
        ps.stimID = char(md(3));
        ps.wordRelation = char(md(5));
        if (strcmp(ps.wordRelation,'ortho')) && (strcmpi(ps.phase,'test'))
            ps.orthoNeighbor = char(md(6));
        else
            ps.correctKey = md(4);
        end
      end
   end