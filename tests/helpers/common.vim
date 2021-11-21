function! Prepare( lines, startPosCommand )
    silent %delete _
    call append(0, a:lines)
    1
    execute 'normal' (empty(a:startPosCommand) ? '0' : a:startPosCommand) 
endfunction
