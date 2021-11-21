" Test forward motion on normal words. 
source helpers/motionSequence.vim
call vimtest#StartTap()

for s:motion in ['w', ',w']
    call TestMotionSequence(
    \   ["press w on '1' 1234.56789 jump '.', then *5%, then",
    \    "  go, @next@ line"],
    \   ["      a b  cde f   gh     i    j    l    mno  p   ",
    \    "  r s tu   v w  "],
    \   s:motion, '0', 'sentence')
endfor

call vimtest#Quit()
