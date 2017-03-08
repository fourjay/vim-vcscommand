setlocal readonly
set nonumber

function! s:search_revision( direction )
    let l:flags = 'W'
    if a:direction ==# 'reverse'
        let l:flags = 'bW'
    endif
    call search('^commit ', l:flags )
    normal! zz
endfunction

nnoremap <buffer> <nowait> ]] :call <SID>search_revision('forward')<cr>
nnoremap <buffer> <nowait> [[ :call <SID>search_revision('reverse')<cr>

nnoremap <buffer> <nowait> d :call vcscommand#revision#diff_prior()<cr>
nnoremap <buffer> <nowait> <enter> :call vcscommand#revision#diff_prior()<cr>

