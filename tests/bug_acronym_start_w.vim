" Test forward motion on CamelCase words. 
source helpers/motionSequence.vim
call vimtest#StartTap()

call TestMotionSequence(
\   'a VCSCommandMapping',
\   '  a  b      c',
\   ',w', '0', 'ACRONYMCamelWord')

call vimtest#Quit()
