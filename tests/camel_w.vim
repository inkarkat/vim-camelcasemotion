" Test forward motion on CamelCase words. 
source helpers/motionSequence.vim
call vimtest#StartTap()

call TestMotionSequence(
\   'set Script31337PathAndNameWithoutExtension11=%~dpn0',
\   '    a     b    c   d  e   f      g        h i  j  k',
\   ',w', '0', 'CamelLine')
call TestMotionSequence(
\   'set Script31337PathANDNameWITHOUTExtension11=%~dpn0',
\   '    a     b    c   d  e   f      g        h i  j  k',
\   ',w', '0', 'CamelACRONYMLine')

call vimtest#Quit()
