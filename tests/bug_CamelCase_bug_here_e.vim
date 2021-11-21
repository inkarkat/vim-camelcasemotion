" Test forward-to-end motion on CamelCase_bug_here and Capitalized_bug_here.
source helpers/motionSequence.vim
call vimtest#StartTap()

call TestMotionSequence(
\   'CamelCase_bug_here',
\   '    a   b   c    d',
\   ',e', '0', 'CamelCase_bug_here')
call TestMotionSequence(
\   'Capitalized_bug_here',
\   '          a   b    c',
\   ',e', '0', 'Capitalized_bug_here')

call vimtest#Quit()
