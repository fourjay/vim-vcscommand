
" Clears all current VCS output buffers of the specified type for a given source.
function! vcscommand#utility#WipeCommandBuffers(originalBuffer, VCSCommand)
	let l:buffer = 1
	while l:buffer <= bufnr('$')
		if getbufvar(l:buffer, 'VCSCommandOriginalBuffer') == a:originalBuffer
			if getbufvar(l:buffer, 'VCSCommandCommand') == a:VCSCommand
				execute 'bw' l:buffer
			endif
		endif
		let l:buffer = l:buffer + 1
	endwhile
endfunction

" Resets the buffer setup state of the original buffer for a given VCS scratch
" buffer.
" Returns:  The VCS buffer number in a passthrough mode.
function! vcscommand#utility#MarkOrigBufferForSetup(buffer)
	checktime
	if a:buffer > 0
		let l:origBuffer = VCSCommandGetOriginalBuffer(a:buffer)
		" This should never not work, but I'm paranoid
		if l:origBuffer != a:buffer
			call setbufvar(l:origBuffer, 'VCSCommandBufferSetup', 0)
		endif
	endif
	return a:buffer
endfunction

" Displays the given error in a consistent faction.  This is intended to be
" invoked from a catch statement.
function! vcscommand#utility#ReportError(error)
	echohl WarningMsg|echomsg 'VCSCommand:  ' . a:error|echohl None
endfunction

" Creates the given mapping by prepending the contents of
" 'VCSCommandMapPrefix' (by default '<Leader>c') to the given shortcut and
" mapping it to the given plugin function.  If a mapping exists for the
" specified shortcut + prefix, emit an error but continue.  If a mapping
" exists for the specified function, do nothing.

function! vcscommand#utility#CreateMapping(shortcut, expansion, display)
	let lhs = VCSCommandGetOption('VCSCommandMapPrefix', '<Leader>c') . a:shortcut
	if !hasmapto(a:expansion)
		try
			execute 'nmap <silent> <unique>' lhs a:expansion
		catch /^Vim(.*):E227:/
			if(&verbose != 0)
				echohl WarningMsg|echomsg 'VCSCommand:  mapping ''' . lhs . ''' already exists, refusing to overwrite.  The mapping for ' . a:display . ' will not be available.'|echohl None
			endif
		endtry
	endif
endfunction
