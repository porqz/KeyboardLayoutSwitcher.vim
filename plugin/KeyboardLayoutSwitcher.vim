" Smart keyboard switching

" Properties

" Index of default keyboard layout
if !exists("g:kls_defaultInputSourceIndex")
	let g:kls_defaultInputSourceIndex = 0 " Use 0 if you are using default english keyboard layout (U.S.)
endif

" Path to KeyboardLayoutSwitcher binary
if !exists("g:kls_switcherPath")
	let g:kls_switcherPath = findfile('bin/KeyboardLayoutSwitcher', &rtp)
endif

" Layout storing when Vim’s focus is lost / gained
if !exists("g:kls_focusSwitching")
	let g:kls_focusSwitching = 1 " Enabled
endif

" Storing layouts of each tab
if !exists("g:kls_tabSwitching")
	let g:kls_tabSwitching = 1 " Enabled
endif

" Storing layout on InsertLeave and restoring on InsertEnter
if !exists("g:kls_insertEnterRestoresLast")
	let g:kls_insertEnterRestoresLast = 0 " Disabled
endif


" Methods

" Store index of current keyboard layout into variable
function! s:kls_StoreCurrentInputSource()
	let t:kls_currentInputSourceIndex = system(g:kls_switcherPath)

	return t:kls_currentInputSourceIndex
endfunction

" Switch to default input source (kls_defaultInputSourceIndex)
function! s:kls_SwitchToDefaultInputSource()
	return system(g:kls_switcherPath . " " . g:kls_defaultInputSourceIndex)
endfunction

function! SwitchToDefaultInputSource()
    call s:kls_SwitchToDefaultInputSource()
endfunction

" Restore stored index of keyboard layout from variable
function! s:kls_RestoreLastInputSource()
	if exists("t:kls_currentInputSourceIndex")
		return system(g:kls_switcherPath . " " . t:kls_currentInputSourceIndex)
	else
		return s:kls_SwitchToDefaultInputSource()
	endif
endfunction

" Store index of current keyboard layout into variable and
" switch to default input source (kls_defaultInputSourceIndex)
function! s:kls_StoreCurrentAndSwitchToDefaultInputSource()
  call s:kls_StoreCurrentInputSource()
  call s:kls_SwitchToDefaultInputSource()
endfunction


" Events

if g:kls_focusSwitching != 0
	autocmd FocusLost  * call s:kls_StoreCurrentInputSource()
	autocmd FocusGained * call s:kls_RestoreLastInputSource()
endif

if g:kls_tabSwitching != 0
	autocmd TabLeave  * call s:kls_StoreCurrentInputSource()
	autocmd TabEnter * call s:kls_RestoreLastInputSource()
endif

autocmd VimEnter * call s:kls_SwitchToDefaultInputSource()

if g:kls_insertEnterRestoresLast != 0
  autocmd InsertEnter * call s:kls_RestoreLastInputSource()
  autocmd InsertLeave * call s:kls_StoreCurrentAndSwitchToDefaultInputSource()
else
  autocmd InsertLeave * call s:kls_SwitchToDefaultInputSource()
endif

noremap <silent> <Esc><Esc> :call SwitchToDefaultInputSource()<CR>
