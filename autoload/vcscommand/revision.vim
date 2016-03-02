" do math on dotted revisions i.e. 
function! vcscommand#revision#math(revision, interval)
    " If it's just a number, do the math
    if a:revision =~ '^[0-9]\+$'
        return a:revision + a:interval
    " if it's a dotted revision, separate out the parts
    elseif a:revision =~ '^[0-9]\+\.[0-9]\+$'
        let parts = split( a:revision, '\.')
        let minor = parts[1]
        let minor += a:interval
        return parts[0] . "." . minor
    endif
    return ''
endfunction

function! vcscommand#revision#get_line(line_number)
    let line = getline(a:line_number)
    " rcslog style
    if line =~ '^revision'
        return substitute(line, "^revision ", "", "")
    " (dotted?) number as first field
    elseif line =~ '^[0-9.]\+ '
        return substitute( line, ' .*', '', '')
    " SVN style revision
    elseif line =~ '^r[0-9]\+ \| [0-9-] .* [0-9]\+ lines$'
        let first =  substitute( line, ' | .*', '', '')
        return substitute( first, '^[ ]*r', '', '')
    elseif &filetype ==  'SVNAnnotate'
        let trimmed  =  substitute( line, '^     ', '', '')
        echom "trimmed " . trimmed
        return substitute( trimmed, '[ ].*', '', '')
    else
        return ''
    endif
endfunction

function! vcscommand#revision#get()
    " try line first
    let result = vcscommand#revision#get_line( line('.') )
    if ! result
        let bottom = line('.') - 2
        let top = line('.') + 1
        for i in range( bottom, top)
            let result = vcscommand#revision#get_line(i)
            if result
                break
            endif
        endfor
    endif
    return result
endfunction

function! vcscommand#revision#diff_prior()
    let revision = vcscommand#revision#get()
    if ! revision
        return
    endif
    let prior = vcscommand#revision#math(revision, -1)
    " close the log/blame window when multi version split
    if prior
        normal q
    endif
    execute 'VCSVimDiff ' .  revision . ' ' . prior
endfunction
