" Smart keyboard switching

if !has("macunix")
	finish
endif

" Keyboard layout switcher object initialize
let g:KLS = {}

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

" Set mappings
if !exists("g:kls_mappings")
	let g:kls_mappings = 1 " Enabled
endif


" Methods

" Store index of current keyboard layout into variable
function! g:KLS.StoreCurrentInputSource()
	let t:kls_currentInputSourceIndex = system(g:kls_switcherPath) 

	return t:kls_currentInputSourceIndex
endfunction

" Switch to default input source (kls_defaultInputSourceIndex)
function! g:KLS.SwitchToDefaultInputSource()
	return system(g:kls_switcherPath . " " . g:kls_defaultInputSourceIndex)
endfunction

" Restore stored index of keyboard layout from variable
function! g:KLS.RestoreLastInputSource()
	if exists("t:kls_currentInputSourceIndex")
		return system(g:kls_switcherPath . " " . t:kls_currentInputSourceIndex)
	else
		return g:KLS.SwitchToDefaultInputSource()
	endif
endfunction

" Store index of current keyboard layout into variable and
" switch to default input source (kls_defaultInputSourceIndex)
function! g:KLS.StoreCurrentAndSwitchToDefaultInputSource()
  call g:KLS.StoreCurrentInputSource()
  call g:KLS.SwitchToDefaultInputSource()
endfunction

" Events

if g:kls_focusSwitching != 0
	autocmd FocusLost  * call g:KLS.StoreCurrentInputSource()
	autocmd FocusGained * call g:KLS.RestoreLastInputSource()
endif

if g:kls_tabSwitching != 0
	autocmd TabLeave  * call g:KLS.StoreCurrentInputSource()
	autocmd TabEnter * call g:KLS.RestoreLastInputSource()
endif

autocmd VimEnter * call g:KLS.SwitchToDefaultInputSource()

if g:kls_insertEnterRestoresLast != 0
  autocmd InsertEnter * call g:KLS.RestoreLastInputSource()
  autocmd InsertLeave * call g:KLS.StoreCurrentAndSwitchToDefaultInputSource()
else
  autocmd InsertLeave * call g:KLS.SwitchToDefaultInputSource()
endif

" Keys mappings

if g:kls_mappings != 0
  noremap : :silent call g:KLS.SwitchToDefaultInputSource()<CR>:
  noremap <silent> <Esc><Esc> :silent call g:KLS.SwitchToDefaultInputSource()<Esc><Esc>
endif
