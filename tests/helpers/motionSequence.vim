source helpers/common.vim

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
function! s:MarkCol( text, col )
    return substitute(a:text, '\%' . a:col . 'c.', '[\0]', '')
endfunction
function! TestMotionSequenceWithSetting( lines, cursorPoints, motionMapping, startPosCommand, description, setting )
    call Prepare(a:lines, a:startPosCommand)
    if ! empty(a:setting)
	execute 'set' a:setting
    endif

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

	let l:description = printf('%s over %s, motion #%d, %s', a:motionMapping, a:description, l:cnt + 1, a:setting)
	let l:point = l:points[l:cnt]
	if l:currentPos == l:point
	    call vimtap#Pass(l:description)
	else
	    let l:diag =
	    \   printf('expected cursor in col %d: %s', l:point[1],      s:MarkCol(getline(l:point[0])     , l:point[1])) . "\n" .
	    \   printf('but cursor was  in col %d: %s', l:currentPos[1], s:MarkCol(getline(l:currentPos[0]), l:currentPos[1]))
	    if l:currentPos[0] != l:point[0]
		let l:diag .= printf("\nof line %d rather than %d", l:currentPos[0], l:point[0])
	    endif

	    call vimtap#Fail(l:description)
	    call vimtap#Diag("Test '" . strtrans(l:description) . "' failed:\n" . l:diag)

	    break   " Doesn't make sense to continue with a wrong position.
	endif
    endfor
endfunction
function! TestMotionSequence( lines, cursorPoints, motionMapping, startPosCommand, description )
    call TestMotionSequenceWithSetting(a:lines, a:cursorPoints, a:motionMapping, a:startPosCommand, a:description, 'isk+=_')
    call TestMotionSequenceWithSetting(a:lines, a:cursorPoints, a:motionMapping, a:startPosCommand, a:description, 'isk-=_')
endfunction
