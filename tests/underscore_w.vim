" Test forward motion on underscore words. 
source helpers/motionSequence.vim
call vimtest#StartTap()

call TestMotionSequence(
\   'set script_31337_path_and_name_without_extension_11=%~dpn0',
\   '    a      b     c    d   e    f       g         h i  j  k',
\   ',w', '0', 'underscore_line')
call TestMotionSequence(
\   'set SCRIPT_31337_PATH_AND_NAME_WITHOUT_EXTENSION_11=%~dpn0',
\   '    a      b     c    d   e    f       g         h i  j  k',
\   ',w', '0', 'UNDERSCORE_LINE')

call vimtest#Quit()
