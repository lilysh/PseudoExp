clear();
expmode = input('TMS [1=ON; 0=OFF]: ');
subcode = input('Subject code: ', 's');
sex = input('Subject sex (m/f): ', 's');
age = input('Subject age: ', 's');
session = input('Session [1, 2, or 3]: ');
phase = input('Phase [practice, study, or test]: ', 's');
if strcmp(phase, 'practice')
   block = input('Block [word, face, or object]: ', 's');
else
   block = input('Block [word1, word2, face, or object]: ', 's');
end
button = input('Button for real stimuli [left or right]: ', 's');
resume = input('Resume? [1 = yes, 0 = no]: ');
pseudoExp(expmode, subcode, sex, age, session, phase, block, button, resume);