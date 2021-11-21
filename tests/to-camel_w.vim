" Test ,w text object on CamelCase words. 
source helpers/textObject.vim
call vimtest#StartTap()

call TestTextObjects(
\   'set Script31337PathANDNameWITHOUTExtension11=%~dpn0',
\   ['Script', '31337', 'Path', 'AND', 'Name', 'WITHOUT', 'Extension', '11', '=%~', 'dpn', "0\n"],
\   'i,w', '0w', 'CamelACRONYMLine')

call vimtest#Quit()
