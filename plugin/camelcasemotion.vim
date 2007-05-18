" camelcasemotion.vim: Mappings for motion through CamelCaseWords. 
"
" USAGE:
"   Defines motions ',w', ',b' and ',e' (similar to 'w', 'b', 'e'), which
"   do not move wordwise (forward/backward), but Camel-wise; i.e. to word
"   boundaries and uppercase letters. Also works on underscore notation, where
"   words are delimited by underscore ('_') characters. 
"   These motions can be used in normal mode, operator-pending mode (cp.
"   :help operator), and visual mode. 
"
" EXAMPLE:
"   (CamelCase:)
"   set Script31337PathAndNameWithoutExtension11=%~dpn0
"   set Script31337PathANDNameWITHOUTExtension11=%~dpn0
"   (underscore_notation:)
"   set script_31337_path_and_name_without_extension_11=%~dpn0
"   set SCRIPT_31337_PATH_AND_NAME_WITHOUT_EXTENSION_11=%~dpn0
"
" ,w moves to ([x] is cursor position): [s]et, [s]cript, [3]1337, [p]ath, [a]nd,
"   [n]ame, [without, [e]xtension, [1]1, [d]pn0
" ,b moves to: [d]pn0, [1]1, [e]xtension, [w]ithout, ...
" ,e moves to: se[t], scrip[t], 3133[7], pat[h], an[d], nam[e], withou[t],
"   extensio[n], 1[1], dpn[0]
"
" Source: vimtip #1016
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" REVISION	DATE		REMARKS 
"	005	16-May-2007	Added support for underscore notation. 
"				Added support for "forward to end of word"
"				(',e') motion. 
"	004	16-May-2007	Improved search pattern so that
"				UppercaseWORDSInBetween and digits are handled,
"				too. 
"	003	15-May-2007	Changed mappings from <Leader>w to ,w; 
"				other \w mappings interfere here, because it's
"				irritating when the cursor jump doesn't happen
"				immediately, because VIM waits whether the
"				mapping is complete. ,w is faster to type that
"				\w (and, because of the left-right touch,
"				preferred over gw). 
"				Added visual mode mappings. 
"	0.02	15-Feb-2006	BF: missing <SID> for omaps. 
"	0.01	11-Oct-2005	file creation

" Avoid installing twice or when in compatible mode
if exists("loaded_camelcasemotion")
    finish
endif
let loaded_camelcasemotion = 1

function! s:CamelCaseMotion( count, direction )
    "echo "count is " . a:count
    let l:i = 0
    while l:i < a:count
	if a:direction == 'e'
	    "call search( '\>\|\(\a\|\d\)\+\ze_', 'We' )
	    call search( '\>\|\(\a\|\d\)\+\ze_\|\u\l\+\|\u\u\+\ze\u\l\|\d\+', 'We' )
	elseif a:direction == 'E'
	    " Note: The "operator forward to end" motion doesn't work properly
	    " when it reaches the end of line; the final character of the
	    " moved-over word remains. This is because we have to search for
	    " '$', because searching for '^' in combination with the 'We' (jump
	    " to end of search result) does not work. 
	    "call search( '$\|\>.\|\(\a\|\d\)\+_', 'We' )
	    call search( '$\|\>.\|\(\a\|\d\)\+_\|\u\l\+.\|\u\u\+\ze\l\|\d\+.', 'We' )
	else
	    " CamelCase: Jump to beginning of either (start of word, Word, WORD,
	    " 123). 
	    " Underscore notation: Jump to the beginning of an underscore-separated
	    " word or number. 
	    "call search( '\<\|\u', 'W' . a:direction )
	    "call search( '\<\|\u\(\l\+\|\u\+\ze\u\)\|\d\+', 'W' . a:direction )
	    "call search( '\<\|\u\(\l\+\|\u\+\ze\u\)\|\d\+\|_\zs\(\a\|\d\)\+', 'W' . a:direction )
	    call search( '\<\(\u\+\ze\u\)\?\|_\zs\(\a\|\d\)\+\|\u\l\+\|\u\u\+\ze\u\l\|\d\+', 'W' . a:direction )
	endif
	let l:i = l:i + 1
    endwhile
endfunction

" It would be logical to use 'command! -count=1', but that doesn't work with the
" normal mode mapping: When a count is typed before the mapping, the ':' will
" convert a count of 3 into ':.,+2MyCommand', but ':3MyCommand' would be
" required to use -count and <count>. 
command! -range CamelCaseForwardMotion call <SID>CamelCaseMotion(<line2>-<line1>+1, '')
command! -range CamelCaseBackwardMotion call <SID>CamelCaseMotion(<line2>-<line1>+1, 'b')
command! -range CamelCaseForwardToEndMotion call <SID>CamelCaseMotion(<line2>-<line1>+1, 'e')

"------------------------------------------------------------------------------

" Normal mode motions:
" The optional [count] before the motion is passed to the custom command as a
" range in the form '.,.+x'. This seems to be an undocumented feature. To
" retrieve the count, the difference needs to be calculated. This motion will
" fail with "invalid range" if the resulting end-line ('.+x') is larger than the
" actual number of lines in the buffer (i.e. when you execute the motion with a
" large count near the end of the buffer). 

"nnoremap <script> <silent> ,w :call search('\<\<Bar>\u', 'W')<CR>
nnoremap <script> <silent> ,w :CamelCaseForwardMotion<CR>
"nnoremap <script> <silent> ,b :call search('\<\<Bar>\u', 'Wb')<CR>
nnoremap <script> <silent> ,b :CamelCaseBackwardMotion<CR>
"
nnoremap <script> <silent> ,e :CamelCaseForwardToEndMotion<CR>
" We do not provide the fourth "backward to end" motion (,E), because it is
" seldomly used. 


" Operator-pending motions:
" The optional [count] before the motion doesn't seem to be propagated to the
" custom command. The custom command is executed only once, even if a higher
" count has been specified. In order to recognize the optional [count], multiple
" mappings including the counts are defined. 

"onoremap <script> ,w :call search('\<\<Bar>\u', 'W')<CR>
onoremap <script> <silent> ,w :call <SID>CamelCaseMotion(1, '')<CR>
onoremap <script> <silent> 1,w :call <SID>CamelCaseMotion(1, '')<CR>
onoremap <script> <silent> 2,w :call <SID>CamelCaseMotion(2, '')<CR>
onoremap <script> <silent> 3,w :call <SID>CamelCaseMotion(3, '')<CR>
onoremap <script> <silent> 4,w :call <SID>CamelCaseMotion(4, '')<CR>
onoremap <script> <silent> 5,w :call <SID>CamelCaseMotion(5, '')<CR>
onoremap <script> <silent> 6,w :call <SID>CamelCaseMotion(6, '')<CR>
onoremap <script> <silent> 7,w :call <SID>CamelCaseMotion(7, '')<CR>
onoremap <script> <silent> 8,w :call <SID>CamelCaseMotion(8, '')<CR>
onoremap <script> <silent> 9,w :call <SID>CamelCaseMotion(9, '')<CR>
"onoremap <script> <silent> ,b :call search('\<\<Bar>\u', 'Wb')<CR>
onoremap <script> <silent> ,b :call <SID>CamelCaseMotion(1, 'b')<CR>
onoremap <script> <silent> 1,b :call <SID>CamelCaseMotion(1, 'b')<CR>
onoremap <script> <silent> 2,b :call <SID>CamelCaseMotion(2, 'b')<CR>
onoremap <script> <silent> 3,b :call <SID>CamelCaseMotion(3, 'b')<CR>
onoremap <script> <silent> 4,b :call <SID>CamelCaseMotion(4, 'b')<CR>
onoremap <script> <silent> 5,b :call <SID>CamelCaseMotion(5, 'b')<CR>
onoremap <script> <silent> 6,b :call <SID>CamelCaseMotion(6, 'b')<CR>
onoremap <script> <silent> 7,b :call <SID>CamelCaseMotion(7, 'b')<CR>
onoremap <script> <silent> 8,b :call <SID>CamelCaseMotion(8, 'b')<CR>
onoremap <script> <silent> 9,b :call <SID>CamelCaseMotion(9, 'b')<CR>
"
onoremap <script> <silent> ,e :call <SID>CamelCaseMotion(1, 'E')<CR>
onoremap <script> <silent> 1,e :call <SID>CamelCaseMotion(1, 'E')<CR>
onoremap <script> <silent> 2,e :call <SID>CamelCaseMotion(2, 'E')<CR>
onoremap <script> <silent> 3,e :call <SID>CamelCaseMotion(3, 'E')<CR>
onoremap <script> <silent> 4,e :call <SID>CamelCaseMotion(4, 'E')<CR>
onoremap <script> <silent> 5,e :call <SID>CamelCaseMotion(5, 'E')<CR>
onoremap <script> <silent> 6,e :call <SID>CamelCaseMotion(6, 'E')<CR>
onoremap <script> <silent> 7,e :call <SID>CamelCaseMotion(7, 'E')<CR>
onoremap <script> <silent> 8,e :call <SID>CamelCaseMotion(8, 'E')<CR>
onoremap <script> <silent> 9,e :call <SID>CamelCaseMotion(9, 'E')<CR>


" Visual mode motions:
" This one is more direct, but causes more flickering because the ex command is
" echoed in the command line. 
"vnoremap <script> ,w <Esc>`>:call <SID>CamelCaseMotion(1,'')<CR>v`<o
vnoremap <script> ,w <Esc>`>,wv`<o
vnoremap <script> 1,w <Esc>`>1,wv`<o
vnoremap <script> 2,w <Esc>`>2,wv`<o
vnoremap <script> 3,w <Esc>`>3,wv`<o
vnoremap <script> 4,w <Esc>`>4,wv`<o
vnoremap <script> 5,w <Esc>`>5,wv`<o
vnoremap <script> 6,w <Esc>`>6,wv`<o
vnoremap <script> 7,w <Esc>`>7,wv`<o
vnoremap <script> 8,w <Esc>`>8,wv`<o
vnoremap <script> 9,w <Esc>`>9,wv`<o
"vnoremap <script> ,b <Esc>`<:call <SID>CamelCaseMotion(1,'b')<CR>v`>o
vnoremap <script> ,b <Esc>`<,bv`>o
vnoremap <script> 1,b <Esc>`<1,bv`>o
vnoremap <script> 2,b <Esc>`<2,bv`>o
vnoremap <script> 3,b <Esc>`<3,bv`>o
vnoremap <script> 4,b <Esc>`<4,bv`>o
vnoremap <script> 5,b <Esc>`<5,bv`>o
vnoremap <script> 6,b <Esc>`<6,bv`>o
vnoremap <script> 7,b <Esc>`<7,bv`>o
vnoremap <script> 8,b <Esc>`<8,bv`>o
vnoremap <script> 9,b <Esc>`<9,bv`>o
"
vnoremap <script> ,e <Esc>`>:call <SID>CamelCaseMotion(1,'E')<CR>v`<o
vnoremap <script> 1,e <Esc>`>:call <SID>CamelCaseMotion(1,'E')<CR>v`<o
vnoremap <script> 2,e <Esc>`>:call <SID>CamelCaseMotion(2,'E')<CR>v`<o
vnoremap <script> 3,e <Esc>`>:call <SID>CamelCaseMotion(3,'E')<CR>v`<o
vnoremap <script> 4,e <Esc>`>:call <SID>CamelCaseMotion(4,'E')<CR>v`<o
vnoremap <script> 5,e <Esc>`>:call <SID>CamelCaseMotion(5,'E')<CR>v`<o
vnoremap <script> 6,e <Esc>`>:call <SID>CamelCaseMotion(6,'E')<CR>v`<o
vnoremap <script> 7,e <Esc>`>:call <SID>CamelCaseMotion(7,'E')<CR>v`<o
vnoremap <script> 8,e <Esc>`>:call <SID>CamelCaseMotion(8,'E')<CR>v`<o
vnoremap <script> 9,e <Esc>`>:call <SID>CamelCaseMotion(9,'E')<CR>v`<o

