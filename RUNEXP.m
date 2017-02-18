clear();
expmode = input('TMS [1=ON; 0=OFF]: ');
subcode = input('Subject code: ', 's');
session = input('Session [1, 2, or 3]: ');
phase = input('Phase [practice, study, or test]: ', 's');
if strcmp(phase, 'practice')
   block = input('Block [word, face, or object]: ', 's');
else
   block = input('Block [word1, word2, face, or object]: ', 's');
end
button = input('Button for real stimuli [one or two]: ', 's');
resume = input('Resume? [1 = yes, 0 = no]: ');
pseudoExp(expmode, subcode, session, phase, block, button, resume);