function [phase, block] = checkArgs( argPhase, argBlock )
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
  if strcmpi(argBlock, 'object')
      block = 'Object';
  end    
end