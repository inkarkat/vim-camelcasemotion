" Test forward motion on CamelCase words. 
source helpers/motionSequence.vim
call vimtest#StartTap()

call TestMotionSequence(
\   'CamelCase_BugIsHere',
\   '     a    b  c d   ',
\   ',w', '0', 'CamelCase_BugIsHere')

call vimtest#Quit()
