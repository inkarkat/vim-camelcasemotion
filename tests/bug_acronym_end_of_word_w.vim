" Test forward motion on CamelCaseACRONYM.
source helpers/motionSequence.vim
call vimtest#StartTap()

call TestMotionSequence(
\   'a CommandMappingVCS',
\   '  a      b      c',
\   ',w', '0', 'CamelCaseACRONYM')
call TestMotionSequence(
\   'a openSSL here',
\   '  a   b   c',
\   ',w', '0', 'wordACRONYM')

call vimtest#Quit()
