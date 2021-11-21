if ! vimtest#features#SupportsNormalWithCount()
    call vimtest#BailOut('All mappings of camelcasemotion need support for :normal with count')
endif

call vimtest#AddDependency('vim-ingo-library')

runtime plugin/camelcasemotion.vim

" Also make "#" a keyword character (same as I have for Vimscript, for easy
" reproduction in the test script itself).
set iskeyword+=#
