" Test backward motion on underscore words. 
source helpers/motionSequence.vim
call vimtest#StartTap()

call TestMotionSequence(
\   'set script_31337_path_and_name_without_extension_11=%~dpn0',
\   'k   j      i     h    g   f    e       d         c b  a   ',
\   ',b', '$', 'underscore_line')
call TestMotionSequence(
\   'set SCRIPT_31337_PATH_AND_NAME_WITHOUT_EXTENSION_##11##_ss',
\   'k   j      i     h    g   f    e       d         c b    a ',
\   ',b', '$', 'UNDERSCORE_LINE')

call vimtest#Quit()
