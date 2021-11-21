" Test forward motion on CamelCase words. 
source helpers/motionSequence.vim
call vimtest#StartTap()

call TestMotionSequence(
\   'set Script31337PathAndNameWithoutExtension11=%~dpn0',
\   '    a     b    c   d  e   f      g        h i  j  k',
\   ',w', '0', 'CamelLine')
call TestMotionSequence(
\   'set Sc#ipt31337PathANDNameWITHOUT##tension11##id55%',
\   '    a     b    c   d  e   f      g        h     i j',
\   ',w', '0', 'CamelACRONYMLine')
call TestMotionSequence(
\   'set Script31337Path%%%nameWithoutExtension98levelArt',
\   '    a     b    c   d  e   f      g        h      k ',
\   ',w', '0', 'Camel%%%line')
call TestMotionSequence(
\   'set sc#iptCountPath%%%nameWithoutExtension98levelArt',
\   '    a     b    c   d  e   f      g        h      k ',
\   ',w', '0', 'ca#elLine')

call vimtest#Quit()
