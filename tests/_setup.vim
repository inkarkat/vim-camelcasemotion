if ! vimtest#features#SupportsNormalWithCount()
    call vimtest#BailOut('All mappings of camelcasemotion need support for :normal with count')
endif

runtime plugin/camelcasemotion.vim
