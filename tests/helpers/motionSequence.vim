function! s:RetrievePoints( markerText )
    let l:markerText = (type(a:markerText) == type([]) ? a:markerText : [a:markerText])
    let l:points = {}
    for l:line in range(len(l:markerText))
	let l:idx = -1
	while 1
	    let l:idx = match(l:markerText[l:line], '\S', l:idx + 1)
	    if l:idx == -1 | break | endif

	    let l:points[l:markerText[l:line][l:idx]] = [l:line + 1, l:idx + 1]
	endwhile
    endfor

    return map(sort(keys(l:points)), 'l:points[v:val]')
endfunction
function! TestMotionSequence( lines, cursorPoints, motionMapping, startPosCommand, description )
    silent %delete _
    call append(0, a:lines)
    1
    execute 'normal' (empty(a:startPosCommand) ? '0' : a:startPosCommand) 

    let l:points = s:RetrievePoints(a:cursorPoints)
    "echomsg string(l:points)

    let l:prevPos = getpos('.')[1:2]
    for l:cnt in range(len(l:points))
	execute 'normal' a:motionMapping
	let l:currentPos = getpos('.')[1:2]
	if l:currentPos == l:prevPos
	    call vimtap#Fail('cursor did not move: ' . string(l:currentPos))
	    return
	endif

	call vimtap#Is(l:currentPos, l:points[l:cnt], a:description . ', motion #' . (l:cnt + 1))
    endfor
endfunction
