
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
