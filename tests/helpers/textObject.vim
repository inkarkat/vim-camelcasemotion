source helpers/common.vim

function! TestTextObject( lines, expectedText, textObjectMapping, startPosCommand, description )
    call Prepare(a:lines, a:startPosCommand)
    let @" = ''
    execute 'normal y' . a:textObjectMapping
    return vimtap#Is(@", a:expectedText, printf('select %s via %s', a:description, a:textObjectMapping))
endfunction

function! TestTextObjects( lines, expected, textObjectMapping, startPosCommand, description)
    let l:expected = ''
    for l:idx in range(len(a:expected))
	let l:expected .= a:expected[l:idx]
	let l:count = (l:idx > 0 ? l:idx + 1 : '')
	if ! TestTextObject(a:lines, l:expected, l:count . a:textObjectMapping, a:startPosCommand, (l:idx + 1) . ' from ' . a:description)
	    break
	endif
    endfor
endfunction
