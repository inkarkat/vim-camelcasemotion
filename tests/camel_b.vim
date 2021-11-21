" Test backward motion on CamelCase words. 
source helpers/motionSequence.vim
call vimtest#StartTap()

call TestMotionSequence(
\   'set Script31337PathAndNameWithoutExtension11=%~dpn0',
\   'k   j     i    h   g  f   e      d        c b  a   ',
\   ',b', '$', 'CamelLine')
call TestMotionSequence(
\   'set Sc#ipt31337PathANDNameWITHOUT##tension11##id55%',
\   'j   i     h    g   f  e   d      c        b     a  ',
\   ',b', '$', 'CamelACRONYMLine')
call TestMotionSequence(
\   'set Script31337Path%%%nameWithoutExtension98levelArt',
\   'j   i     h    g   f  e   d      c        b      a ',
\   ',b', '$', 'Camel%%%line')
call TestMotionSequence(
\   'set sc#iptCountPath%%%nameWithoutExtension98levelArt',
\   'j   i     h    g   f  e   d      c        b      a ',
\   ',b', '$', 'ca#elLine')

call vimtest#Quit()
