""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Aleksandr Slobodov (N)VIM config
" https://github.com/hadalhw17/vimconf
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

:source $MYVIMRC/../Project.vim

" -VIMRC MISC------------------------------------------------------------------
  let $VIMHOME = $HOME."/.vim"
  let $SWAPDIR = $VIMHOME."/swap//"
  augroup vimrc
    autocmd!
    autocmd BufEnter ~/.vimrc set foldmethod=manual
    autocmd BufWritePost $MYVIMRC source $MYVIMRC "Automatically source .vimrc when saving it
    autocmd BufWritePost ~/.vimrc source "~/.vimrc" "Automatically source .vimrc when saving it

" -GLOBAL SETTINGS-------------------------------------------------------------
  set encoding=UTF-8 
  set title                   "We can change the tile of the window
  set noswapfile							"Turn off swap file generation
  set clipboard=unnamed				"Use the OS clipboard for copying/pasting
  set nu                      "Show file numbers
  set relativenumber

  set foldmethod=manual
  set foldlevelstart=99
  " set expandtab               "Never use hard tabs
  set nojoinspaces            "Avoid double spaces when joining lines
  set shiftwidth=4            "One tab = 2 spaces (auto indent)
  set shiftround              "Only ident to multiple of shiftwidth
  set tabstop=4
  " set softtabstop=4           "Tab key inserts 2 spaces
  set textwidth=80            "Maximum characters before wrapping
  set wrap                    "Wrap line after textwidth characters
  set hlsearch                "Highlight search matches
  set listchars=tab:»·,nbsp:+,trail:·,extends:→,precedes:←
  set autoindent
  set smartindent
  set ignorecase
  set smartcase
  set cindent
  set exrc                    "Enable per directory .exrc file
  set laststatus=2						"Always show status bar
  set cursorline              "Enable highlighting the cursor line
  set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P\ %y\ %(\ %m%)\ %{&ft}\ \ %l:\ %L,\ col:%c\ %s

  lua require("config.lazy")

  hi default CursorWord cterm=underline gui=underline

  " Leader
  let mapleader = "\<Space>"

  " Display options
  :set showmode
  :set showcmd
  " Set status line display
  :set statusline=%F%m%r%h%w\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [BUFFER=%n]\ %{strftime('%c')}

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
  :set pastetoggle=<F2>
  :set listchars=tab:▸▸,trail:~,extends:>,precedes:<,space:·
  :syntax enable
  :syntax on
  :set noerrorbells
  :set visualbell
  :set ruler
  :set wildmenu
  :set laststatus=2
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
  nmap <silent> <leader>sv :so "~/.vimrc"<CR>

  " Search hotkeys
  nmap <leader>gf :vimgrep /<c-r>=expand("<cword>")<cr>/../*/*<CR> /<c-r>=expand("<cword>")<cr><CR><s-n>
  nmap <leader>n :cnext<CR>
  map <leader>l :set list!<CR> " Toggle tabs and EOL

  nmap <c-s> :update<cr> " Save with C-s
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
  nnoremap <C-K>h :ClangdSwitchSourceHeader<CR>

  " FONT size adjust command
  nnoremap <C-Up> :silent! let &guifont = substitute(&guifont, ':h\zs\d\+', '\=eval(submatch(0)+1)', 'g')<CR>
  nnoremap <C-Down> :silent! let &guifont = substitute(&guifont, ':h\zs\d\+', '\=eval(submatch(0)-1)', 'g')<CR>

  " Autocomplete with TAB instead of Enter
  set completeopt=menu,menuone
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

  " Toggle completion on/off with F2 key
  nnoremap <F2> :call ToggleCompletion()<CR>

  let g:nvimCmpEnabled = v:false
  function! ToggleCompletion()
    if g:nvimCmpEnabled
      lua require('cmp').setup{ enabled = false }
      let g:nvimCmpEnabled = v:false
    else
      lua require('cmp').setup{ enabled = true }
      let g:nvimCmpEnabled = v:true
    endif
    call UpdateTitleBar()
  endfunction

  " Toggle LSP on/off with F3 key
  nnoremap <F3> :call ToggleLSP()<CR>
  let g:nvimLSPEnabled = v:false
  let g:nvimPrevCMPEnabledValue = g:nvimCmpEnabled
  function! ToggleLSP()
    if g:nvimLSPEnabled
      :LspStop
      let g:nvimLSPEnabled = v:false
      let g:nvimPrevCMPEnabledValue = g:nvimCmpEnabled 
      let g:nvimCmpEnabled = v:false
    else
      :LspStart
      let g:nvimLSPEnabled = v:true
      let g:nvimCmpEnabled = g:nvimPrevCMPEnabledValue
    endif
    call UpdateTitleBar()
  endfunction

" -Folding---------------------------------------------------------------------
  " https://coderwall.com/p/usd_cw/a-pretty-vim-foldtext-function
  set foldmethod=manual
  set foldlevelstart=99
  "set fillchars=fold:\  

  set foldtext=FoldText()
  function! FoldText()
    let l:lpadding = &fdc
    redir => l:signs
    execute 'silent sign place buffer='.bufnr('%')
    redir End
    let l:lpadding += l:signs =~ 'id=' ? 2 : 0

    if exists("+relativenumber")
      if (&number)
        let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
      elseif (&relativenumber)
        let l:lpadding += max([&numberwidth, strlen(v:foldstart - line('w0')), strlen(line('w$') - v:foldstart), strlen(v:foldstart)]) + 1
      endif
    else
      if (&number)
        let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
      endif
    endif
    " expand tabs
    let l:start = substitute(getline(v:foldstart), '\t', repeat(' ', &tabstop), 'g')
    let l:end = substitute(substitute(getline(v:foldend), '\t', repeat(' ', &tabstop), 'g'), '^\s*', '', 'g')

    let l:info = ' (' . (v:foldend - v:foldstart) . ')'
    let l:infolen = strlen(substitute(l:info, '.', 'x', 'g'))
    let l:width = winwidth(0) - l:lpadding - l:infolen

    let l:separator = ' … '
    let l:separatorlen = strlen(substitute(l:separator, '.', 'x', 'g'))
    let l:start = strpart(l:start , 0, l:width - strlen(substitute(l:end, '.', 'x', 'g')) - l:separatorlen)
    let l:text = l:start . ' … ' . l:end

    return l:text . repeat(' ', l:width - strlen(substitute(l:text, ".", "x", "g"))) . l:info
  endfunction

" -Building--------------------------------------------------------------------
  compiler msvc
  
  function! Build()
    :silent make clean
    :silent make
    :cw
    :redraw!
  endfunction
  
  function! Clean()
    :silent make clean
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
  
  function! Clean()
    :silent make clean
  endfunction
  
  function! Rebuild()
    :silent call Clean()
    :silent call Build()
  endfunction
  
  function! ShowBuildOutput()
    :cw
    :redraw!
  endfunction
  
  call SetMakeMakeprg() " Use Make as default make program
  
  set errorformat+=\\\ %#%f(%l)\ :\ %#%t%[A-z]%#\ %m
  set errorformat+=,%f:\ error\ %s:%m
  set errorformat+=,%f:\ fatal\ error\ %s:%m
  autocmd VimResized * :wincmd =
  
  " Rebuild
  nmap <F9> :silent call Build()<cr>
  nmap <F10> :silent call Rebuild()<cr>
  nmap <script> <silent> <F4> :call OpenPrefixWindow()<cr>
  
  " Quickfix
  function! OpenPrefixWindow()
    let currentWindow = winnr()
    if &buftype == "quickfix"
      "bprev
      "wincmd w
      wincmd q
    else
      copen
      wincmd L
     " only
     " copen
     " if (currentWindow == 1)
     "   wincmd L
     " else
     "   wincmd H
     " endif
    endif
  endfunction
  
  au QuickFixCmdPost * :call OpenPrefixWindow()

" -TODO extraction-------------------------------------------------------------
  function! ExtractTodo()
    silent cgete system('todo.bat') | wincmd L
  endfunction

  silent command! Todo call ExtractTodo()

" -Colorscheme and font--------------------------------------------------------
  colo slate
  :set background=dark
  set guifont= "FiraCode Nerd Font:h10"

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

    let l:fileName = expand("%t")
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
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
  vim.keymap.set('n', '<leader>cd', function() vim.cmd("cd %:p:h") end)

  -- LSP-ZERO
  local lsp = require('lsp-zero').preset({
  name = 'minimal',
  set_lsp_keymaps = true,
  manage_nvim_cmp = true,
  suggest_lsp_servers = false,
  virtual_text = true
  })

local cmp = require('cmp')

lsp.setup_nvim_cmp({
  mapping = lsp.defaults.cmp_mappings({
  -- Do not capture TAB key!
    ['<Tab>'] = vim.NIL, 
  })
})

  lsp.setup()

vim.diagnostic.config({
  -- Use keybinding 'gl' to display diagnostics if this is disabled
  virtual_text = false, 
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = false,
  float = true,
})

vim.filetype.add({
  extension = {
    cfx = 'fx',
    cfi = 'fx'
  }
})

-- vim.api.nvim_create_autocmd("BufRead,BufNewFile", {
--     pattern = {"*.cfx", "*.cfi"},
--     callback = function()
--       vim.bo.filetype = "fx"
--     end,
-- })

EOF

" End of vimrc
