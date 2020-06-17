let $PATH .= ':' . expand('~/.vim/plugged/vim-terraform-completion/bin')

if exists('g:loaded_neomake')
    if !exists('g:neomake_terraform_tffilter_plan')
        let g:neomake_terraform_tffilter_plan = 0
    endif

    if g:neomake_terraform_tffilter_plan == 0
        let args = ['%:p']
    else
        let args = ['%:p','--with-plan']
    endif

    let g:neomake_terraform_terraform_validate_maker = {
                \ 'exe' : 'terraform',
                \ 'append_file': 0,
                \ 'cwd': '%:p:h',
                \ 'args': ['validate', '-no-color'],
                \ 'errorformat': 'Error\ loading\ files\ Error\ parsing %f:\ At\ %l:%c:\ %m'
                \ }

    let g:neomake_terraform_tffilter_maker = {
                \ 'exe': 'tffilter',
                \ 'append_file': 0,
                \ 'cwd': '%:p:h',
                \ 'args': args,
                \ 'errorformat': '%f:%l:%m'
                \ }

    let g:neomake_terraform_tflint_maker = {
                \ 'exe' : 'tflint',
                \ 'append_file': 0,
                \ 'cwd': '%:p:h',
                \ 'args': [],
                \ 'errorformat': '%+P%f,%p%t%*[^:]:%l %m,%-Q'
                \ }

    let g:neomake_terraform_enabled_makers = ['terraform_validate', 'tflint', 'tffilter']
endif
