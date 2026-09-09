""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Aleksandr Slobodov (N)VIM config
" https://github.com/hadalhw17/vimconf
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:config_dir = fnamemodify($MYVIMRC, ':p:h')
let g:plugin_file = g:config_dir . '/Project.vim'
execute 'source' fnameescape(g:plugin_file)

" -VIMRC MISC------------------------------------------------------------------
  let $VIMHOME = $HOME."/.vim"
  let $SWAPDIR = $VIMHOME."/swap//"

" -GLOBAL SETTINGS-------------------------------------------------------------
  set encoding=UTF-8 
  set title                   "We can change the tile of the window
  set noswapfile							"Turn off swap file generation
  set undofile                "Persistent undo across sessions
  set clipboard=unnamed				"Use the OS clipboard for copying/pasting
  set nu                      "Show file numbers
  set relativenumber

  " set expandtab               "Never use hard tabs
  set nojoinspaces            "Avoid double spaces when joining lines
  set shiftwidth=4            "One tab = 2 spaces (auto indent)
  set shiftround              "Only ident to multiple of shiftwidth
  set tabstop=4
  " set softtabstop=4           "Tab key inserts 2 spaces
  set textwidth=80            "Maximum characters before wrapping
  set wrap                    "Wrap line after textwidth characters
  set hlsearch                "Highlight search matches
  set listchars=tab:»·,trail:·,extends:→,precedes:←,nbsp:+,space:·
  set autoindent
  set smartindent
  set ignorecase
  set smartcase
  set cindent
  set laststatus=3						"Single global status line (lualine)
  set cursorline              "Enable highlighting the cursor line

  lua require("config.lazy")
  lua require("config.lsp")
  lua require("config.ui")


  " Leader
  let mapleader = "\<Space>"

  " Display options
  :set showmode
  :set showcmd

  " Indentation
  :set autoindent
  :set shiftwidth=4
  " :set smarttab
  :set noexpandtab
  :set tabstop=4
  :set shiftround
  :set copyindent

  " Editor
  " Hidden characters
  :set mouse=a
  :syntax enable
  :syntax on
  :set noerrorbells
  :set visualbell
  :set ruler
  :set wildmenu
  :set hidden
  :set formatoptions-=cro
  " Highlight matching pairs of brackets. Use the '%' character to jump between them.
  :set showmatch
  :set matchpairs+=<:>
  " Text rendering
  :set linebreak
  :set scrolloff=5
  :set sidescrolloff=5

  " Misc
  :set autoread
  :set confirm
  :set dir=~/.cache/vim
  :set backupdir=~/.cache/vim
  :set history=1000
  :set wildignore+=.pyc,.swp
  :set backspace=indent,eol,start
  " :set autochdir

  " Split
  :set splitright
  :set splitbelow

  " Move between windows without W
  nnoremap <C-J> <C-W><C-J>
  nnoremap <C-K> <C-W><C-K>
  nnoremap <C-L> <C-W><C-L>
  nnoremap <C-H> <C-W><C-H>

  " Search
  :set smartcase
  :set incsearch
  :set showmatch
  :set hlsearch
  :set ignorecase
  :set smartcase
  "

  " Use Q for formatting the current paragraph (or selection)
  vmap Q gq
  nmap Q gqap

  " au BufRead,BufNewFile *.cfx,*.cfi set filetype=fx
  " au BufRead,BufNewFile *.cfx,*.cfi set syntax=fx

" -Keybindings-----------------------------------------------------------------
" Quickly edit/reload the vimrc file
  nmap <silent> <leader>ev :vsp ~/.vimrc<CR>
  nmap <silent> <leader>sv :so $MYVIMRC<CR>

  " Search hotkeys
  nmap <leader>n :cnext<CR>

  " Toggle tabs and EOL
  map <leader>l :set list!<CR>

  " Save with C-s
  nmap <c-s> :update<cr>
  nnoremap <esc> :nohlsearch<cr>
  " TEXT SELECTION WITH ARROWS
  nmap <S-Up> v<Up>
  nmap <S-Down> v<Down>
  nmap <S-Left> v<Left>
  nmap <S-Right> v<Right>
  vmap <S-Up> <Up>
  vmap <S-Down> <Down>
  vmap <S-Left> <Left>
  vmap <S-Right> <Right>

  " LINE DRAGGING WITH ALT ARROWS
  nnoremap <A-down> :m .+1<CR>==
  nnoremap <A-up> :m .-2<CR>==
  inoremap <A-down> <Esc>:m .+1<CR>==gi
  inoremap <A-up> <Esc>:m .-2<CR>==gi
  vnoremap <A-down> :m '>+1<CR>gv=gv
  vnoremap <A-up> :m '<-2<CR>gv=gv

  " LINE DRAGGING WITH ALT HJKL:
  nnoremap <A-j> :m .+1<CR>==
  nnoremap <A-k> :m .-2<CR>==
  inoremap <A-j> <Esc>:m .+1<CR>==gi
  inoremap <A-k> <Esc>:m .-2<CR>==gi
  vnoremap <A-j> :m '>+1<CR>gv=gv
  vnoremap <A-k> :m '<-2<CR>gv=gv

  " Buffer access
  nnoremap <tab> :buffer *

  " FONT size adjust command
  nnoremap <C-Up> :silent! let &guifont = substitute(&guifont, ':h\zs\d\+', '\=eval(submatch(0)+1)', 'g')<CR>
  nnoremap <C-Down> :silent! let &guifont = substitute(&guifont, ':h\zs\d\+', '\=eval(submatch(0)-1)', 'g')<CR>

  " Autocomplete with TAB instead of Enter (native menu only;
  " nvim-cmp, LSP and the F2/F3 toggles live in lua/config/lsp.lua)
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" -Folding---------------------------------------------------------------------
  " Buffers with a treesitter parser get structural expr folds (see the
  " nvim-treesitter spec in plugins.lua); everything else stays manual.
  " Fold summary lines use Neovim's native syntax-highlighted foldtext.
  set foldmethod=manual
  set foldlevelstart=99

" -Building--------------------------------------------------------------------
  compiler msvc
  " Filter huge quickfix lists with :Cfilter /pattern/
  packadd cfilter

  " Builds run async via vim-dispatch (:Make); quickfix opens when they finish
  function! Build()
    :Make
  endfunction

  function! Clean()
    :Make clean
  endfunction
  
  function! SetCMakeMakeprg()
    set makeprg=cmake
  endfunction
  
  function! SetNMakeMakeprg()
    set makeprg=nmake
  endfunction
  
  function! SetMakeMakeprg()
    set makeprg=make
  endfunction
  
  function! Rebuild()
    :Make clean all
  endfunction
  
  function! ShowBuildOutput()
    :cw
    :redraw!
  endfunction
  
  call SetMakeMakeprg() " Use Make as default make program
  
  set errorformat+=\\\ %#%f(%l)\ :\ %#%t%[A-z]%#\ %m
  set errorformat+=,%f:\ error\ %s:%m
  set errorformat+=,%f:\ fatal\ error\ %s:%m

  " Rebuild
  nmap <F9> :silent call Build()<cr>
  nmap <F10> :silent call Rebuild()<cr>
  nmap <script> <silent> <F4> :call OpenPrefixWindow()<cr>
  
  " Quickfix
  function! OpenPrefixWindow()
    let currentWindow = winnr()
    if &buftype == "quickfix"
      wincmd q
    else
      copen
    endif
  endfunction
  
  augroup buildwindows
    autocmd!
    autocmd VimResized * :wincmd =
    autocmd QuickFixCmdPost * :call OpenPrefixWindow()
  augroup END

" -TODO extraction-------------------------------------------------------------
  function! ExtractTodo()
    silent cgete system('todo.bat') | wincmd L
  endfunction

  silent command! Todo call ExtractTodo()

" -Colorscheme and font--------------------------------------------------------
  colo kanso-ink
  :set background=dark
  :set guifont=FiraCode\ Nerd\ Font:h10

" -Project file loading--------------------------------------------------------
  let g:project#name = ""
  let g:vimprj#currentProjectName = ""

  function! UpdateTitleBar()
    let l:completionStatus = ""
    if g:nvimCmpEnabled == v:true
      let l:completionStatus = " [ 🧩 Autocompletion enabled ]"
    endif

    if g:nvimLSPEnabled == v:true
      let l:completionStatus .= " [ 🧩 LSP enabled ]"
    endif

    let iconList = { 'qf':'🔧', 'help':'🎓', 'netrw':'📁', 'default':'🗒️', '':'❓' }

    let icon = iconList["default"]
    if has_key(iconList, &filetype)
      let icon = iconList[&filetype]
    endif

    let l:fileName = expand("%:t")
    if len(l:fileName) == 0
      let l:fileName = &filetype
    endif

    let l:fileName = icon . ' ' . l:fileName

    let &titlestring = g:vimprj#currentProjectName . " :: " .  l:fileName . l:completionStatus
  endfunction

  function! CheckProjectVim()
    call CheckProjectImpl(getcwd())
    call UpdateTitleBar()
  endfunction

  function! CheckProjectImpl(path)
    let file_path = a:path . "/project.vim"
    if filereadable(file_path)
      execute "source" file_path
      let g:vimprj#path = a:path
      let g:vimprj#currentProjectName = g:project#name
    else
      let g:vimprj#currentProjectName = nr2char(0x1F4C1) . a:path
      let g:vimprj#path = a:path
      let s:parentPath = fnamemodify(a:path, ':h')
      if a:path !=? s:parentPath
        call CheckProjectImpl(s:parentPath)
        let g:vimprj#currentProjectName = nr2char(0x1F4C1) . "No Project"
        let g:vimprj#path = getcwd()
      endif
    endif
    call UpdateTitleBar()
  endfunction

  function! LoadProjectCommand(path)
    Clear
    execute "cd " . a:path
    let sessionFile = a:path . "/Session.vim"
    execute "source " . sessionFile
    call CheckProjectVim()
  endfunction

  augroup dirchange
    autocmd!
    autocmd! dirChanged * call CheckProjectVim()
    autocmd BufEnter * call UpdateTitleBar()
  augroup END

  command! -nargs=1 Project :silent! call LoadProjectCommand(<q-args>)

  call CheckProjectVim()


"--Skeleton files -------------------------------------------------------------
function! UpdateSkeletonBuffer(extension)
  "Header file
  let bufname = substitute(fnamemodify(bufname('%'), ':t'), '[^[:alnum:]]', '_', 'g')
  if a:extension == "h"
    silent! execute '%s/%header_name%/' . toupper(bufname) . '/g'
    let l:namespace = g:project#defaultNamespace
    if len(l:namespace) == 0
      let l:namespace = "my_name_space"
    endif
    silent! execute '%s/%namespace%/' . l:namespace . '/g'

    if search('%cursor%', 'c') > 0
      normal diW
    endif
    silent! execute '%s/%%/' . g:project#defaultNamespace . '/g'
  endif

  " set the buffer as modified. We don't want to get confused thinking it's an existing file
  call setbufvar(bufnr(), '&modified', 1)

endfunction

augroup skeletons
  au!
  autocmd BufNewFile *.* silent! execute '0r ~/.vim/templates/skeleton.'.expand("<afile>:e") | call UpdateSkeletonBuffer(expand("<afile>:e"))
  autocmd BufNewFile CMakeLists.txt execute '0r ~/.vim/templates/CMakeLists.txt' | call UpdateSkeletonBuffer("<afile>:e")
  autocmd BufNewFile project.vim execute '0r ~/.vim/templates/project.vim' | call UpdateSkeletonBuffer("<afile>:e")
augroup END

let g:cmp_widget_border = 'rounded'
"--LUA based configurations----------------------------------------------------
lua <<EOF

--Auto reload vimrc
vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("ConfigReloaded", {clear = true}),
	-- Backslash is an escape char in autocmd patterns, so normalize paths to /
	pattern = {
		vim.fs.normalize(vim.env.MYVIMRC),
		vim.fs.normalize(vim.env.HOME .. "/.vimrc"),
	},
	callback = function()
		vim.cmd("source " .. vim.env.MYVIMRC)
		vim.notify("Autoreloaded " .. vim.env.MYVIMRC, vim.log.levels.INFO)
	end,
})

vim.keymap.set('n', '<leader>cd', function() vim.cmd("cd %:p:h") end)

-- Split minified JSON into readable lines; nvim is line-oriented, so many
-- short lines render fast while one huge line does not
vim.api.nvim_create_user_command("JsonPretty", function()
	local tool = vim.fn.executable("jq") == 1 and { "jq", "." } or { "python", "-m", "json.tool" }
	local text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
	local res = vim.system(tool, { stdin = text, text = true }):wait()
	if res.code ~= 0 then
		vim.notify("JsonPretty failed: " .. (res.stderr or ""), vim.log.levels.ERROR)
		return
	end
	local lines = vim.split(res.stdout, "\n")
	if lines[#lines] == "" then
		table.remove(lines)
	end
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end, {})

vim.filetype.add({
  extension = {
    cfx  = 'fx',
    cfi  = 'fx',
    rfx  = 'fx',
    rfi  = 'fx',
    ixx  = "cpp",
    cppm = "cpp",
  }
})

-- vim.api.nvim_create_autocmd("BufRead,BufNewFile", {
--     pattern = {"*.cfx", "*.cfi", "*.rfi", "*.rfx"},
--     callback = function()
--       vim.bo.filetype = "fx"
--       vim.bo.syntax = "fx"
--     end,
-- })

EOF

" End of vimrc
