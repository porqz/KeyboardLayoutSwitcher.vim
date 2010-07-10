" Smart keyboard switching

" Initialize smart keyboard switching global variables

" Use 0 if you are using default english keyboard layout (U.S.)
if !exists("g:defaultInputSourceIndex")
	let g:defaultInputSourceIndex = 0 " Index of default keyboard layout
endif

if !exists("g:switcherPath")
	let g:switcherPath = "~/.vim/bin/KeyboardLayoutSwitcher" " Path to KeyboardLayoutSwitcher binary
endif

" Store index of current keyboard layout into variable
function! StoreCurrentInputSource()
	let t:currentInputSourceIndex = system(g:switcherPath) 

	return t:currentInputSourceIndex
endfunction

function! SwitchToDefaultInputSource()
	return system(g:switcherPath . " " . g:defaultInputSourceIndex)
endfunction

" Restore stored index of keyboard layout from variable
function! RestoreLastInputSource()
	if exists("t:currentInputSourceIndex")
		return system(g:switcherPath . " " . t:currentInputSourceIndex)
	else
		return SwitchToDefaultInputSource()
	endif
endfunction

if exists("g:kls_focusSwitching") && g:kls_focusSwitching != 0
	autocmd FocusLost  * call StoreCurrentInputSource()
	autocmd FocusGained * call RestoreLastInputSource()
endif

if exists("g:kls_tabSwitching") && g:kls_tabSwitching != 0
	autocmd TabLeave  * call StoreCurrentInputSource()
	autocmd TabEnter * call RestoreLastInputSource()
endif

autocmd VimEnter,InsertLeave * call SwitchToDefaultInputSource()

noremap : :silent call SwitchToDefaultInputSource()<CR>:
noremap <silent> <Esc><Esc> :silent call SwitchToDefaultInputSource()<Esc><Esc>
cnoremap <silent> <Esc><Esc> :silent call SwitchToDefaultInputSource()<Esc><Esc>

