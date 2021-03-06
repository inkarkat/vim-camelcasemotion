" camelcasemotion.vim: Motion through CamelCaseWords and underscore_notation.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"   - ingo/motion/helper.vim autoload script (optional)
"
" Copyright: (C) 2007-2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" REVISION	DATE		REMARKS
"   2.00.012	10-Dec-2014	Rename camelcasemotion#InnerMotion() to
"				camelcasemotion#TextObject().
"   2.00.011	12-Jun-2014	Make test for 'virtualedit' option values also
"				account for multiple values.
"   2.00.010	22-Mar-2014	Add camelcasemotion#DeletePrevious() for a
"				special i_CTRL-W replacement that observes
"				CamelCase and underscore_words.
"   2.00.009	11-Jan-2014	Factor out special treatment for visual and
"				operator-pending motions to
"				ingo#motion#helper#AdditionalMovement(), but
"				keep internal fallback to keep the dependency to
"				ingo-library optional.
"   2.00.008	27-Jun-2013	BUG: Correct additional stops on _ (for all
"				b/e/w motions) when :set iskeyword-=_.
"   2.00.007	19-Sep-2012	BUG: Correct missing stop on ACRONYM at the end
"				of a CamelCaseACRONYM. Reported by dlee at
"				https://github.com/bkad/CamelCaseMotion/issues/8
"   2.00.006	15-Sep-2012	Also handle move to the buffer's very last
"				character in operator-pending mode "forward to
"				end" motion by temporarily setting 'virtualedit'
"				to "onemore".
"   2.00.005	30-Mar-2012	BUG: Correct missing stops on
"				underscore_notation as the second part following
"				a Capitalized word.
"				Cp. tests/bug_CamelCase_bug_here_e.vim.
"   2.00.004	03-Dec-2011	BUG: Correct missing stops on numbers and
"				CamelCase as the second part of an
"				underscore_word in "CamelCase_BugIsHere".
"				This was probably introduced by the recent
"				changes.
"				Cp. tests/bug_CamelCase_BugIsHere_w.vim.
"   2.00.003	12-Nov-2011	Many motion fixes due to enhanced test suite,
"				most to support any keyword character in
"				addition to lowercase letters.
"   1.52.002	18-Oct-2011	FIX: Correct forward-to-end motion over
"				lowercase part in "lowerCamel". Found this by
"				chance in GitHub fork by Kevin Lee (bkad).
"				BUG: Correct wrong stop on second letter of
"				ACRONYM at the beginning of a word "AXBCText".
"   1.50.001	05-May-2009	Do not create mappings for select mode;
"				according to|Select-mode|, printable character
"				commands should delete the selection and insert
"				the typed characters.
"				Moved functions from plugin to separate autoload
"				script.
"   				file creation

silent! call ingo#motion#helper#DoesNotExist()	" Execute a function to force autoload.
if exists('*ingo#motion#helper#AdditionalMovement')
function! s:AdditionalMovement()
    return ingo#motion#helper#AdditionalMovement()
endfunction
else
function! s:AdditionalMovement()
    let l:isSpecialLastLineTreatment = 1
    let l:save_ww = &whichwrap
    set whichwrap+=l
    if l:isSpecialLastLineTreatment && line('.') == line('$') && &virtualedit !~# 'all\|onemore'
	" For the last line in the buffer, that still doesn't work in
	" operator-pending mode, unless we can do virtual editing.
	let l:save_virtualedit = &virtualedit
	set virtualedit=onemore
	normal! l
	augroup IngoLibraryTempVirtualEdit
	    execute 'autocmd! CursorMoved * set virtualedit=' . l:save_virtualedit . ' | autocmd! IngoLibraryTempVirtualEdit'
	augroup END
    else
	normal! l
    endif
    let &whichwrap = l:save_ww
endfunction
endif
function! s:Move( direction, count, mode )
    " Note: There is no inversion of the regular expression character class
    " 'keyword character' (\k). We need an inversion "non-keyword" defined as
    " "any non-whitespace character that is not a keyword character" (e.g.
    " [!@#$%^&*()]). This can be specified via a non-whitespace character in
    " whose place no keyword character matches (\k\@!\S).

    "echo "count is " . a:count
    let l:i = 0
    while l:i < a:count
	if a:direction == 'e'
	    " "Forward to end" motion.
	    "call search( '\>\|\(\a\|\d\)\+\ze_', 'We' )
	    " end of ...
	    " number, possibly followed by word | ACRONYM followed by CamelCase, number, or non-alphabetic keyword | word followed by CamelCase, ACRONYM, or number | CamelCase | underscore_notation | non-keyword | word
	    " Note: Branches are ordered from specific to unspecific so that
	    " in case of multiple matches, the more specific (and usually
	    " longer) one is used.
	    call search( '\d\+\%(\%(\u\|\d\|_\)\@!\k\)*\|\u\+\ze\%(\u\l\|\d\|\%(\a\@!\k\)\)\|\%(\%(\u\|\d\|_\)\@!\k\)\+\ze\%(\u\|\d\)\|\u\%(\%(\u\|\d\|_\)\@!\k\)\+\|\%(\a\|\d\)\+\ze_\|\%(\%(\k\|_\)\@!\S\)\+\|\%(\%(\d\|_\)\@!\k\)\+\>', 'We' )
	    " Note: word must be defined as '\k\>'; '\>' on its own somehow
	    " dominates over the previous branch. Plus, \k must exclude the
	    " underscore, or a trailing one will be incorrectly moved over, and
	    " numbers.
	    if a:mode == 'o'
		" Note: Special additional treatment for operator-pending mode
		" "forward to end" motion.
		call s:AdditionalMovement()
	    endif
	else
	    " Forward (a:direction == '') and backward (a:direction == 'b')
	    " motion.

	    let l:direction = (a:direction == 'w' ? '' : a:direction)

	    " CamelCase: Jump to beginning of either (start of word, Word, WORD,
	    " 123).
	    " Underscore_notation: Jump to the beginning of an underscore-separated
	    " word or number.
	    "call search( '\<\|\u', 'W' . l:direction )
	    "call search( '\<\|\u\(\l\+\|\u\+\ze\u\)\|\d\+', 'W' . l:direction )
	    "call search( '\<\|\u\(\l\+\|\u\+\ze\u\)\|\d\+\|_\zs\(\a\|\d\)\+', 'W' . l:direction )
	    " beginning of ...
	    " word | empty line | non-keyword after whitespaces | non-whitespace after word | number, possibly followed by word | start of ACRONYM followed by CamelCase, number, word, or at the end of the keyword | CamelCase | number after underscore | non-underscore non-whitespace after underscore | word after ACRONYM
	    " Note: Branches are ordered from unspecific to specific, so that
	    " the cursor moves the least amount of text.
	    call search( '\<\D\|^$\|\%(^\|\s\)\+\zs\k\@!\S\|_\@!\>\S\|\d\+\%(\%(\u\|\d\|_\)\@!\k\)*\|\u\@<!\u\+\ze\%(\u\l\|\d\|\%(\a\@!\k\)\|_\@!\>\)\|\u\l\+\|_\zs\%(\d\+\)\|_\zs\%(_\@!\S\)\|\%(\u\u\)\@<=\%(\%(\u\|\d\)\@!\k\)', 'W' . l:direction )
	    " Note: word must be defined as '\<\D' to avoid that a word like
	    " 1234Test is moved over as [1][2]34[T]est instead of [1]234[T]est
	    " because \< matches with zero width, and \d\+ will then start
	    " matching '234'. To fix that, we make \d\+ be solely responsible
	    " for numbers by taken this away from \< via \<\D. (An alternative
	    " would be to replace \d\+ with \D\%#\zs\d\+, but that one is more
	    " complex.) All other branches are not affected, because they match
	    " multiple characters and not the same character multiple times.
	endif
	let l:i = l:i + 1
    endwhile
endfunction

function! camelcasemotion#Motion( direction, count, mode )
"*******************************************************************************
"* PURPOSE:
"   Perform the motion over CamelCaseWords or underscore_notation.
"* ASSUMPTIONS / PRECONDITIONS:
"   none
"* EFFECTS / POSTCONDITIONS:
"   Move cursor / change selection.
"* INPUTS:
"   a:direction	one of 'w', 'b', 'e'
"   a:count	number of "words" to move over
"   a:mode	one of 'n', 'o', 'v', 'iv' (latter one is a special visual mode
"		when inside the inner "word" text objects.
"* RETURN VALUES:
"   none
"*******************************************************************************
    " Visual mode needs special preparations and postprocessing;
    " normal and operator-pending mode breeze through to s:Move().

    if a:mode == 'v'
	" Visual mode was left when calling this function. Reselecting the current
	" selection returns to visual mode and allows to call search() and issue
	" normal mode motions while staying in visual mode.
	normal! gv
    endif
    if a:mode == 'v' || a:mode == 'iv'

	" Note_1a:
	if &selection != 'exclusive' && a:direction == 'w'
	    normal! l
	endif
    endif

    call s:Move( a:direction, a:count, a:mode )

    if a:mode == 'v' || a:mode == 'iv'
	" Note: 'selection' setting.
	if &selection == 'exclusive' && a:direction == 'e'
	    " When set to 'exclusive', the "forward to end" motion (',e') does not
	    " include the last character of the moved-over "word". To include that, an
	    " additional 'l' motion is appended to the motion; similar to the
	    " special treatment in operator-pending mode.
	    normal! l
	elseif &selection != 'exclusive' && a:direction != 'e'
	    " Note_1b:
	    " The forward and backward motions move to the beginning of the next "word".
	    " When 'selection' is set to 'inclusive' or 'old', this is one character too far.
	    " The appended 'h' motion undoes this. Because of this backward step,
	    " though, the forward motion finds the current "word" again, and would
	    " be stuck on the current "word". An 'l' motion before the CamelCase
	    " motion (see Note_1a) fixes that.
	    normal! h
	endif
    endif
endfunction

function! camelcasemotion#TextObject( direction, count )
    " If the cursor is positioned on the first character of a CamelWord, the
    " backward motion would move to the previous word, which would result in a
    " wrong selection. To fix this, first move the cursor to the right, so that
    " the backward motion definitely will cover the current "word" under the
    " cursor.
    normal! l

    " Move "word" backwards, enter visual mode, then move "word" forward. This
    " selects the inner "word" in visual mode; the operator-pending mode takes
    " this selection as the area covered by the motion.
    if a:direction == 'b'
	" Do not do the selection backwards, because the backwards "word" motion
	" in visual mode + selection=inclusive has an off-by-one error.
	call camelcasemotion#Motion( 'b', a:count, 'n' )
	normal! v
	" We decree that 'b' is the opposite of 'e', not 'w'. This makes more
	" sense at the end of a line and for underscore_notation.
	call camelcasemotion#Motion( 'e', a:count, 'iv' )
    else
	call camelcasemotion#Motion( 'b', 1, 'n' )
	normal! v
	call camelcasemotion#Motion( a:direction, a:count, 'iv' )
    endif
endfunction


function! camelcasemotion#DeletePrevious()
    if col('.') == 1 || search('^\s\+\%#', 'bcnW', line('.'))
	" The CamelCase motion doesn't pull the existing text after the cursor
	" up to the previous line; use the original command at the beginning of
	" a line instead. Also, when there's just whitespace before the cursor,
	" to avoid killing the entire line in one go.
	return "\<C-w>"
    endif

    let s:save_virtualedit = &virtualedit
    set virtualedit=onemore	" Without this, the last character in the line would be left over.
    return "\<C-o>:call camelcasemotion#DeletePreviousCamelCase()\<CR>"
endfunction
function! camelcasemotion#DeletePreviousCamelCase()
    execute "normal! d:call camelcasemotion#Motion('b', 1, 'o')\<CR>"
    let &virtualedit = s:save_virtualedit
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
