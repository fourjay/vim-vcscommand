setlocal readonly
" setlocal nomodifiable

function! s:search_revision( direction )
    let flags = 'W'
    if a:direction == 'reverse'
        let flags = 'bW'
    endif
    call search('^revision', flags )
    normal zz
endfunction

nnoremap <buffer> <nowait> ]] :call <SID>search_revision('forward')<cr>
nnoremap <buffer> <nowait> [[ :call <SID>search_revision('reverse')<cr>

nnoremap <buffer> <nowait> d :call vcscommand#revision#diff_prior()<cr>
nnoremap <buffer> <nowait> <enter> :call vcscommand#revision#diff_prior()<cr>

nnoremap <buffer> <nowait> D :call vcscommand#revision#diff_head()<cr>
