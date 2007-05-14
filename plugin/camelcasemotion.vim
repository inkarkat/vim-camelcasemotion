" camelcasemotion.vim: mappings for motion through CamelCaseWords
"
" Usage:
"   Defines motions ',w' and ',b' (similar to 'w' and 'b'), which
"   do not move wordwise (forward/backward), but Camel-wise; i.e. to word
"   boundaries and uppercase letters. 
"   These motions can be used in normal mode and operator-pending mode (cp.
"   :help operator). 
"
" Source: VimTip #1016
"
" Test:
"   Tested with VIM 6.3 under Windows XP/x86 and HP-UX 11.0/PA-RISC. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" REVISION	DATE		REMARKS 
"	003	15-May-2007	Changed mappings from <Leader>w to ,w; 
"				other \w mappings interfere here, because it's
"				irritating when the cursor jump doesn't happen
"				immediately, because VIM waits whether the
"				mapping is complete. ,w is faster to type that
"				\w (and, because of the left-right touch,
"				preferred over gw). 
"	0.02	15-Feb-2006	BF: missing <SID> for omaps. 
"	0.01	11-Oct-2005	file creation

" Avoid installing twice or when in compatible mode
if exists("loaded_camelcasemotion")
    finish
endif
let loaded_camelcasemotion = 1

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

function! s:CamelCaseMotion( count, direction )
    "echo "count is " . a:count
    let l:i = 0
    while l:i < a:count
	call search( '\<\|\u', 'W' . a:direction )
	let l:i = l:i + 1
    endwhile
endfunction

command! -range CamelCaseForwardMotion call <SID>CamelCaseMotion(<line2>-<line1>+1, '')
command! -range CamelCaseBackwardMotion call <SID>CamelCaseMotion(<line2>-<line1>+1, 'b')

