" do math on dotted revisions i.e. 
function! vcscommand#revision#math(revision, interval) abort
    " If it's just a number, do the math
    if a:revision =~# '^[0-9]\+$'
        return a:revision + a:interval
    " if it's a dotted revision, separate out the parts
    elseif a:revision =~# '^[0-9]\+\.[0-9]\+$'
        let l:parts = split( a:revision, '\.')
        let l:minor = l:parts[1]
        let l:minor += a:interval
        return l:parts[0] . '.' . l:minor
    endif
    return ''
endfunction

function! vcscommand#revision#get_line(line_number) abort
    let l:line = getline(a:line_number)
    " rcslog style
    if l:line =~# '^revision'
        return substitute(l:line, '^revision ', '', '')
    " (dotted?) number as first field
    elseif l:line =~# '^[0-9.]\+ '
        return substitute( l:line, ' .*', '', '')
    " SVN style revision
    elseif l:line =~# '^r[0-9]\+ \| [0-9-] .* [0-9]\+ lines$'
        let l:first =  substitute( l:line, ' | .*', '', '')
        return substitute( l:first, '^[ ]*r', '', '')
    elseif l:line =~# '^commit [0-9a-z]\{20,}$'
        let l:second =  substitute( l:line, '^commit ', '', '')
        return l:second
    elseif &filetype ==#  'SVNAnnotate'
        let l:trimmed  =  substitute( l:line, '^     ', '', '')
        return substitute( l:trimmed, '[ ].*', '', '')
    elseif &filetype ==#  'gitannotate'
        let l:gitid  =  substitute( l:line, ' .*', '', '')
        return l:gitid
    else
        return ''
    endif
endfunction

function! vcscommand#revision#get() abort
    " try line first
    let l:result = vcscommand#revision#get_line( line('.') )
    if ! l:result
        let l:bottom = line('.') - 2
        let l:top = line('.') + 1
        for l:i in range( l:bottom, l:top)
            let l:result = vcscommand#revision#get_line(l:i)
            if l:result
                break
            endif
        endfor
    endif
    return l:result
endfunction

function! vcscommand#revision#diff_prior() abort
    let l:revision = vcscommand#revision#get()
    if ! l:revision
        return
    endif
    let l:prior = vcscommand#revision#math(l:revision, -1)
    " close the log/blame window when multi version split
    if l:prior
        normal! q
    endif
    execute 'VCSVimDiff ' .  l:revision . ' ' . l:prior
endfunction

function! vcscommand#revision#diff_head() abort
    let l:revision = vcscommand#revision#get()
    execute 'VCSVimDiff ' .  l:revision
endfunction
