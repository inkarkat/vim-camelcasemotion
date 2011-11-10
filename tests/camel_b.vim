" Test backward motion on CamelCase words. 
source helpers/motionSequence.vim
call vimtest#StartTap()

call TestMotionSequence(
\   'set Script31337PathAndNameWithoutExtension11=%~dpn0',
\   'k   j     i    h   g  f   e      d        c b  a   ',
\   ',b', '$', 'CamelLine')
call TestMotionSequence(
\   'set Script31337PathANDNameWITHOUTExtension11=%~dpn0',
\   'k   j     i    h   g  f   e      d        c b  a   ',
\   ',b', '$', 'CamelACRONYMLine')

call vimtest#Quit()
