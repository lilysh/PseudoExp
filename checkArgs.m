function [phase, block, sex] = checkArgs( argPhase, argBlock, argSex )

  if strcmpi(argPhase, 'practice')
      phase = 'Practice';
  end
  if strcmpi(argPhase, 'study')
      phase = 'Study';
  end
  if strcmpi(argPhase, 'test')
      phase = 'Test';
  end  
  
  if strcmpi(argBlock, 'word')
      block = 'Word';
  end   
  if strcmpi(argBlock, 'word1')
      block = 'Word1';
  end   
  if strcmpi(argBlock, 'word2')
      block = 'Word2';
  end   

  if strcmpi(argBlock, 'face')
      block = 'Face';
  end  
  if strcmp(argBlock, 'object')
      block = 'Object';
  end    

  if ( strcmpi(argSex, 'male') || strcmpi(argSex, 'M') )
      sex = 'm';
  elseif ( strcmpi(argSex, 'female') || strcmpi(argSex, 'F') )
      sex = 'f';
  elseif isempty(argSex)
      sex = '_';
  else
      sex = '?';
  end  
  
end