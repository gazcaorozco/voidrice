let mapleader =","

"if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
"	echo "Downloading junegunn/vim-plug to manage plugins..."
"	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
"	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
"	autocmd VimEnter * PlugInstall
"endif
"
"call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
"Plug 'tpope/vim-surround'
"Plug 'preservim/nerdtree'
"Plug 'junegunn/goyo.vim'
"Plug 'jreybert/vimagit'
"Plug 'lukesmithxyz/vimling'
"Plug 'vimwiki/vimwiki'
"Plug 'bling/vim-airline'
"Plug 'tpope/vim-commentary'
"Plug 'ap/vim-css-color'
"call plug#end()

set title
set bg=light
set go=a
set mouse=a
"set nohlsearch
set clipboard+=unnamedplus
set noshowmode
set noruler
set laststatus=0
set noshowcmd

" Some basics:
	nnoremap c "_c
	set nocompatible
	filetype plugin on
	syntax on
	set encoding=utf-8
	set number relativenumber
" Enable autocompletion:
	set wildmode=longest,list,full
" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Perform dot commands over visual blocks:
	vnoremap . :normal .<CR>
" Goyo plugin makes text more readable when writing prose:
"	map <leader>f :Goyo \| set bg=light \| set linebreak<CR>
" Spell-check set to <leader>o, 'o' for 'orthography':
	map <leader>o :setlocal spell! spelllang=en_gb<CR>
" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	set splitbelow splitright

" Nerd tree
"	map <leader>n :NERDTreeToggle<CR>
"	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
 "   if has('nvim')
 "       let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
 "   else
 "       let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
 "   endif

"" vimling:
"	nm <leader><leader>d :call ToggleDeadKeys()<CR>
"	imap <leader><leader>d <esc>:call ToggleDeadKeys()<CR>a
"	nm <leader><leader>i :call ToggleIPA()<CR>
"	imap <leader><leader>i <esc>:call ToggleIPA()<CR>a
"	nm <leader><leader>q :call ToggleProse()<CR>

" Shortcutting split navigation, saving a keypress:
"	map <C-h> <C-w>h
"	map <C-j> <C-w>j
"	map <C-k> <C-w>k
"	map <C-l> <C-w>l

" Replace ex mode with gq
	map Q gq

" Check file in shellcheck:
	map <leader>s :!clear && shellcheck -x %<CR>

" Open my bibliography file in split
	map <leader>b :vsp<space>$BIB<CR>
	map <leader>r :vsp<space>$REFER<CR>

" Replace all is aliased to S.
	nnoremap S :%s//g<Left><Left>

" Compile document, be it groff/LaTeX/markdown/etc.
	map <leader>c :w! \| !compiler "<c-r>%"<CR>

" Open corresponding .pdf/.html or preview
	map <leader>p :!opout <c-r>%<CR><CR>

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
	autocmd VimLeave *.tex !texclear %

" Ensure files are read as what I want:
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
	map <leader>v :VimwikiIndex
	let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
"	autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
"	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
"	autocmd BufRead,BufNewFile *.tex set filetype=tex

" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Enable Goyo by default for mutt writing
"	autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
"	autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo | set bg=light
"	autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo\|x!<CR>
"	autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo\|q!<CR>

" Automatically deletes all trailing whitespace and newlines at end of file on save.
"	autocmd BufWritePre * %s/\s\+$//e
"	autocmd BufWritePre * %s/\n\+\%$//e
"	autocmd BufWritePre *.[ch] %s/\%$/\r/e
" autocmd BufWritePre * cal cursor(currPos[1], currPos[2])
	""Alternative that leaves markdown files alone
	function! TrimWhitespace()
  if &filetype!='markdown'
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
  endif
endfunction

command! TrimWhitespace call TrimWhitespace()

" When shortcut files are updated, renew bash and ranger configs with new material:
	autocmd BufWritePost bm-files,bm-dirs !shortcuts
" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults set filetype=xdefaults
	autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
" Recompile dwmblocks on config edit.
	autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }

" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif

" Function for toggling the bottom statusbar:
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
nnoremap <leader>h :call ToggleHiddenAll()<CR>

"My old vimrc
set nocompatible              " be iMproved, required
filetype off                  " required

" If vim is old, you have to 'echo "runtime vimrc" > .vimrc' in ~
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}
Plugin 'vimwiki/vimwiki'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'

"Plugin 'Valloric/YouCompleteMe'
Plugin 'sheerun/vim-polyglot'
Plugin 'lifepillar/vim-mucomplete'
"Plugin 'neoclide/coc.nvim'

"Status bar
Plugin 'vim-airline/vim-airline'

Plugin 'jnurmine/Zenburn'
"Plugin 'altercation/vim-colors-solarized'
" A Vim Plugin for Lively Previewing LaTeX PDF Output
"Plugin 'xuhdev/vim-latex-live-preview'
"Vimtex
Plugin 'lervag/vimtex'
"All your plugins must come before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" For mucomplete
"set completeopt+=menuone
"set completeopt+=noselect
"set shortmess+=c "Shut off completion messages
"set belloff+=ctrlg "If Vim beeps during completion
"let g:mucomplete#enable_auto_at_startup = 1
"let g:mucomplete#completion_delay = 1
"Another example
set completeopt-=preview
set completeopt+=longest,menuone,noinsert
let g:jedi#popup_on_dot = 0  " It may be 1 as well
let g:mucomplete#enable_auto_at_startup = 1

"syntax on
"if has('gui_running')
"	  set background=dark
"	    colorscheme solarized
"    else
"	      colorscheme zenburn
"      endif
      "split navigations
      nnoremap <C-J> <C-W><C-J>
      nnoremap <C-K> <C-W><C-K>
      nnoremap <C-L> <C-W><C-L>
      nnoremap <C-H> <C-W><C-H>
      let g:tex_flavor = "latex"
      "check spelling
"      set spell spelllang=en_gb
      set number
      set relativenumber
      "for tab completion
"      set path+=**
"      set wildmenu
"      set wildignore+=**/node_modules/**
"      set wildmode=longest:list,full
      "For switching between buffers
      nnoremap <C-n> :bnext<CR>
      nnoremap <C-p> :bprevious<CR>
      "Folding
      nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
      vnoremap <Space> zf

			set ignorecase
			set smartcase

      "Highlights searches
      set hlsearch
      hi Search guibg=DarkMagenta
      hi Search guifg=LightYellow
      hi Search ctermbg=DarkMagenta
      hi Search ctermfg=LightYellow
