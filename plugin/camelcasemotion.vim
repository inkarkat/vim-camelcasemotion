" camelcasemotion.vim: mappings for motion through CamelCaseWords
"
" Usage:
"   Defines motions ',w' and ',b' (similar to 'w' and 'b'), which
"   do not move wordwise (forward/backward), but Camel-wise; i.e. to word
"   boundaries and uppercase letters. 
"   These motions can be used in normal mode, operator-pending mode (cp.
"   :help operator), and visual mode. 
"
" CamelCase Example:
"   set Script31337PathAndNameWithoutExtension11=%~dpn0
"   set Script31337PathANDNameWITHOUTExtension11=%~dpn0
" ,w moves to set, script, 31337, path, and, name, without, extension, 11, dpn
"
" Underscore_notation Example:
"   set script_31337_path_and_name_without_extension_11=%~dpn0
"   set SCRIPT_31337_PATH_AND_NAME_WITHOUT_EXTENSION_11=%~dpn0
"
" Source: VimTip #1016
"
" Test:
"   Tested with VIM 6.3 under Windows XP/x86 and HP-UX 11.0/PA-RISC. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" REVISION	DATE		REMARKS 
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
	" CamelCase: Jump to beginning of either (start of word, Word, WORD,
	" 123). 
	" Underscore notation: Jump to the beginning of an underscore-separated
	" word or number. 
	call search( '\<\|\u\(\l\+\|\u\+\ze\u\)\|\d\+\|_\zs\(\a\|\d\)\+', 'W' . a:direction )
	let l:i = l:i + 1
    endwhile
endfunction

command! -range CamelCaseForwardMotion call <SID>CamelCaseMotion(<line2>-<line1>+1, '')
command! -range CamelCaseBackwardMotion call <SID>CamelCaseMotion(<line2>-<line1>+1, 'b')

"------------------------------------------------------------------------------

" Normal mode motions:
" The optional [count] before the motion is passed to the custom command as a
" range in the form '.,.+x'. This seems to be an undocumented feature. To
" retrieve the count, the difference needs to be calculated. This motion will
" fail with "invalid range" if the resulting end-line ('.+x') is larger than the
" actual number of lines in the buffer (i.e. when you execute the motion with a
" large count near the end of the buffer). 

"nmap <silent> ,w :call search('\<\<Bar>\u', 'W')<CR>
nmap <silent> ,w :CamelCaseForwardMotion<CR>
"nmap <silent> ,b :call search('\<\<Bar>\u', 'Wb')<CR>
nmap <silent> ,b :CamelCaseBackwardMotion<CR>



" Operator-pending motions:
" The optional [count] before the motion doesn't seem to be propagated to the
" custom command. The custom command is executed only once, even if a higher
" count has been specified. In order to recognize the optional [count], multiple
" mappings including the counts are defined. 

"omap ,w :call search('\<\<Bar>\u', 'W')<CR>
omap <silent> ,w :call <SID>CamelCaseMotion(1, '')<CR>
omap <silent> 1,w :call <SID>CamelCaseMotion(1, '')<CR>
omap <silent> 2,w :call <SID>CamelCaseMotion(2, '')<CR>
omap <silent> 3,w :call <SID>CamelCaseMotion(3, '')<CR>
omap <silent> 4,w :call <SID>CamelCaseMotion(4, '')<CR>
omap <silent> 5,w :call <SID>CamelCaseMotion(5, '')<CR>
omap <silent> 6,w :call <SID>CamelCaseMotion(6, '')<CR>
omap <silent> 7,w :call <SID>CamelCaseMotion(7, '')<CR>
omap <silent> 8,w :call <SID>CamelCaseMotion(8, '')<CR>
omap <silent> 9,w :call <SID>CamelCaseMotion(9, '')<CR>
"omap <silent> ,b :call search('\<\<Bar>\u', 'Wb')<CR>
omap <silent> ,b :call <SID>CamelCaseMotion(1, 'b')<CR>
omap <silent> 1,b :call <SID>CamelCaseMotion(1, 'b')<CR>
omap <silent> 2,b :call <SID>CamelCaseMotion(2, 'b')<CR>
omap <silent> 3,b :call <SID>CamelCaseMotion(3, 'b')<CR>
omap <silent> 3,b :call <SID>CamelCaseMotion(4, 'b')<CR>
omap <silent> 3,b :call <SID>CamelCaseMotion(5, 'b')<CR>
omap <silent> 3,b :call <SID>CamelCaseMotion(6, 'b')<CR>
omap <silent> 3,b :call <SID>CamelCaseMotion(7, 'b')<CR>
omap <silent> 3,b :call <SID>CamelCaseMotion(8, 'b')<CR>
omap <silent> 3,b :call <SID>CamelCaseMotion(9, 'b')<CR>

" Visual mode motions:
" This one is more direct, but causes more flickering because the ex command is
" echoed in the command line. 
"vmap ,w <Esc>`>:call <SID>CamelCaseMotion(1,'')<CR>v`<o
vmap ,w <Esc>`>,wv`<o
vmap 1,w <Esc>`>1,wv`<o
vmap 2,w <Esc>`>2,wv`<o
vmap 3,w <Esc>`>3,wv`<o
vmap 4,w <Esc>`>4,wv`<o
vmap 5,w <Esc>`>5,wv`<o
vmap 6,w <Esc>`>6,wv`<o
vmap 7,w <Esc>`>7,wv`<o
vmap 8,w <Esc>`>8,wv`<o
vmap 9,w <Esc>`>9,wv`<o
"vmap ,b <Esc>`<:call <SID>CamelCaseMotion(1,'b')<CR>v`>o
vmap ,b <Esc>`<,bv`>o
vmap 1,b <Esc>`<1,bv`>o
vmap 2,b <Esc>`<2,bv`>o
vmap 3,b <Esc>`<3,bv`>o
vmap 4,b <Esc>`<4,bv`>o
vmap 5,b <Esc>`<5,bv`>o
vmap 6,b <Esc>`<6,bv`>o
vmap 7,b <Esc>`<7,bv`>o
vmap 8,b <Esc>`<8,bv`>o
vmap 9,b <Esc>`<9,bv`>o

