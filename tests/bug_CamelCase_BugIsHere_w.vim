" Test forward motion on CamelCase_BugIsHere.
source helpers/motionSequence.vim
call vimtest#StartTap()

call TestMotionSequence(
\   'CamelCase_BugIsHere',
\   '     a    b  c d   ',
\   ',w', '0', 'CamelCase_BugIsHere')

call vimtest#Quit()
