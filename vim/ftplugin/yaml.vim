if exists('g:loaded_neomake')
  let g:neomake_logfile = '/tmp/neomake.log'

  let g:neomake_yaml_enabled_makers = ['yamllint', 'kubelinter']

  let g:neomake_yaml_kubelinter_maker = {
      \ 'exe': 'kube-linter',
      \ 'args': ['lint'],
      \ 'errorformat': '%m',
      \ 'remove_invalid_entries': 0
      \ }
endif
