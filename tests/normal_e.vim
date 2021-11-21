" Test forward-to-end motion on normal words. 
source helpers/motionSequence.vim
call vimtest#StartTap()

for s:motion in ['e', ',e']
    call TestMotionSequence(
    \   ["press w on '1' 1234.56789 jump '.', then *5%, then",
    \    "  go, @next@ line"],
    \   ["    a b  c def    gh    i    j    k    l mn o    p",
    \    "   qr s   tu    v"],
    \   s:motion, '0', 'sentence')
endfor

call vimtest#Quit()
