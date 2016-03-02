setlocal readonly
setlocal nomodifiable

nnoremap <buffer> <nowait> d :call vcscommand#revision#diff_prior()<cr>
nnoremap <buffer> <nowait> <enter> :call vcscommand#revision#diff_prior()<cr>
