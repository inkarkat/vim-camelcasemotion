" Test backward motion on normal words. 
source helpers/motionSequence.vim
call vimtest#StartTap()

for s:motion in ['b', ',b']
    call TestMotionSequence(
    \   ["press w on '1' 1234.56789 jump '.', then *5%, then",
    \    "  go, @next@ line"],
    \   ["v     u t  srq p   on     m    l    k    jih  g   ",
    \    "  f e dc   b a  "],
    \   s:motion, 'j$', 'sentence')
endfor

call vimtest#Quit()
