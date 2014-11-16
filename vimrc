" TODO:
" 1. allow mouse to position cursor

" bootstrap {{{
  set nocompatible

  call plug#begin('~/.vim/plugged')
  " presentation
  Plug 'altercation/vim-colors-solarized'
  Plug 'Valloric/MatchTagAlways'
  Plug 'vim-scripts/CursorLineCurrentWindow'
  Plug 'nathanaelkane/vim-indent-guides'
 " IDE
  Plug 'bling/vim-airline'
  Plug 'scrooloose/nerdtree'
  Plug 'scrooloose/syntastic'
  Plug 'majutsushi/tagbar'
  " syntax
  Plug 'hail2u/vim-css3-syntax'
  Plug 'othree/html5.vim', { 'for': 'html' }
  Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
  Plug 'tpope/vim-markdown', { 'for': 'markdown' }
  Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
  Plug 'cakebaker/scss-syntax.vim'
  Plug 'Valloric/python-indent'
  Plug 'Valloric/xmledit'
  Plug 'helino/vim-json'
  Plug 'octol/vim-cpp-enhanced-highlight'
  Plug 'python.vim'
  Plug 'python_match.vim'
  " source control
"  Plug 'godlygeek/tabular'
"  Plug 'gregsexton/gitv', { 'on': 'Gitv' }
"  Plug 'kien/ctrlp.vim'
" Plug 'mhinz/vim-signify'
"  Plug 'tpope/vim-fugitive' " gitv
  " utility
  Plug 'chrisbra/SudoEdit.vim'
  Plug 'derekwyatt/vim-fswitch'
"  Plug 'maxbrunsfeld/vim-yankstack'
  Plug 'Raimondi/delimitMate'
  Plug 'scrooloose/nerdcommenter'
  Plug 'vim-scripts/closetag.vim'

  call plug#end()
"}}}

" basic config {{{
	syntax on

	set nobackup
	set nowritebackup
    set autochdir

	if exists('+undofile')
		if !isdirectory(expand('~/.vim/tmp')) && exists('*mkdir')
			call mkdir(expand('~/.vim/tmp'), 'p', 0700)
		endif

		set undofile
		set undodir=~/.vim/tmp
	endif

	set fileformats=unix,dos
	set fileformat=unix

	set noerrorbells
	set visualbell

	set showmatch
	set matchtime=5

	set backspace=indent,eol,start
	set shortmess=flmnrxoOrTI
	set iskeyword+=_,$,@,%,#
	set encoding=utf-8
	set termencoding=utf-8
	set title
	set autoread
	set report=0

	let mapleader = ','

	set wildmenu
	set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.dylib,*.dmg,*.pdf
	set wildmode=full
" }}}

" UI options {{{
	" highlight unwanted whitespace {{{
		au ColorScheme * highlight ExtraWhitespace ctermbg=52 guibg=52
		au BufWinEnter * let w:extra_whitespace=matchadd('ExtraWhitespace', '\s\+$', -1)
	" }}}

	" adjust gutter color {{{
		au ColorScheme * highlight SignColumn ctermbg=NONE
	" }}}

	" adjust cursor colors {{{
		au ColorScheme * highlight CursorLine ctermbg=232 guibg=232
		au ColorScheme * highlight CursorColumn ctermbg=232 guibg=232
	" }}}

	" color scheme {{{
		set background=dark
		set t_Co=256
		let g:solarized_termtrans=1
		let g:solarized_termcolors=256
		colorscheme solarized
	" }}}

	" gui options {{{
		if has('gui_running')
			set guioptions-=T
			set guioptions+=e
			set guitablavel=%M\ %t
			set t_Co=256
		endif
	" }}}

	" restore screen {{{
		set restorescreen
	" }}}

	set mouse=a
	set ttyfast
	set ttymouse=xterm2
	if has('mouse_sgr')
		"set ttymouse=sgr
	else
		"set ttymouse=xterm
	endif

	set laststatus=2
	set number
	set numberwidth=5
	set ruler
	set cursorline
	set cursorcolumn
	set showcmd
	set showmode
	set confirm
	set history=1000
	set undolevels=1000
	set viminfo='1000,h,s1000
	set diffopt=filler,context:8,vertical

	" scrolling {{{
		set scrolloff=5
		set sidescrolloff=5
		set scrolljump=5
		set sidescroll=5
	" }}}

	set splitbelow splitright
	set noequalalways
" }}}

" text options {{{
	filetype plugin indent on
	set autoindent
	set copyindent
	set cindent
	set nowrap
	set textwidth=80
	set formatoptions=roqwnlmB1
	set linebreak
	set nostartofline
	set comments=s1:/*,mb:*,ex:*/,f://,b:#,:%,:XCOMM,n:>,fb:-,b:\"

	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o  " no comments on new line

	let c_no_curly_error=1 " don't show an error for C++ lambda syntax

	" search {{{
		set ignorecase
		set smartcase
		set incsearch
		set hlsearch
	" }}}

	" tabs {{{
		set tabstop=4
		set softtabstop=0
		set shiftwidth=4
		set shiftround
		set smarttab
		set noexpandtab
	" }}}
" }}}

" vim-plug {{{
	let g:plug_window = 'botright new'
" }}}

" vim-airline {{{
	let g:airline_powerline_fonts = 1
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tabline#buffer_nr_show = 1
" }}}

" tags {{{
	if has('cscope')
		set cscopeprg=/opt/local/bin/gtags-cscope
		set cscopetag
		set cscopepathcomp=3
		set nocscopeverbose

		let cscope_file=findfile('GTAGS','.;')
		if !empty(cscope_file) && filereadable(cscope_file)
			exe 'cs add' cscope_file getcwd()
		endif
	endif
" }}}

" auto-complete and syntax checking {{{
	"let g:ycm_add_preview_to_completeopt=1
	"let g:ycm_confirm_extra_conf=0
	let g:syntastic_check_on_open=1
	let g:syntastic_enable_signs=0
	let g:syntastic_error_window=1
	let g:syntastic_auto_loc_list=1
	let g:syntastic_quiet_messages={'level': 'warnings'}
	let g:syntastic_stl_format='[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
	let g:syntastic_cpp_check_header = 1
	let g:syntastic_cpp_no_default_include_dirs = 1
	let g:syntastic_cpp_auto_refresh_includes = 1
	let g:syntastic_cpp_compiler_options = '-std=c++11 -Wall -Wextra -Werror -Wpedantic'
	let g:syntastic_cpp_compiler = 'g++-mp-4.9'
	let g:syntastic_cpp_auto_refresh_includes = 1
	highlight SyntasticError     ctermfg=white ctermbg=124 guifg=NONE guibg=NONE gui=undercurl guisp=#ff0000
	highlight SyntasticErrorSign ctermfg=white ctermbg=red guifg=white guibg=red
" }}}

" indent guides {{{
	let g:indent_guides_auto_colors=0
	au VimEnter,ColorScheme * :hi IndentGuidesOdd  ctermbg=234
	au VimEnter,ColorScheme * :hi IndentGuidesEven ctermbg=NONE
" }}}

" delimitMate {{{
	let g:delimitMate_expand_cr=1
	let g:delimitMate_expand_space=1
" }}}

" mappings {{{
	" open nerdtree {{{
		nnoremap <silent> <Leader>t :NERDTreeToggle<CR>
	" }}}

	" open nerdtree {{{
		nnoremap <silent> <Leader>b :TagbarToggle<CR>
	" }}}

	" open syntastic errors {{{
		nnoremap <silent> <Leader>e :Errors<CR>
	" }}}

	" remove search highlight {{{
		nnoremap <silent> <Leader>/ :nohls<CR>
	" }}}

	" reload .vimrc {{{
		nnoremap <silent> <Leader>r :source ~/.vimrc<CR>
	" }}}

	" insert blank line below/above without entering insert mode {{{
		nnoremap - :put=''<CR>
		nnoremap + :put!=''<CR>
	" }}}

	" visual mode indent/unindent {{{
		vnoremap <Tab> >gv
		vnoremap <S-Tab> <gv
	" }}}

	" switch to companion file {{{
		nnoremap <C-o> :FSHere<CR>
	" }}}

	" use tab for bracket matching {{{
	     nmap <Tab> %
	" }}}

	" save file {{{
		map <Esc><Esc> :w<CR>
	" "}}}

	" tagging {{{
		nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>		" C symbol
		map <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>		" defintion
		nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR> 		" functions called by this function
		nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR> 		" funtions calling this function
		nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR> 		" text
		nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR> 		" egrep pattern
		nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR> 		" file
		nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR> 	" files #including this file
	" }}}

	set pastetoggle=<Leader>p
" }}}

" autocommands {{{
augroup General " {{{
	autocmd!
	" vim help {{{
	au FileType help au BufEnter,BufWinEnter <buffer>
				\ setlocal nonumber |
				\ nnoremap <buffer> <Space> <C-]> |
				\ nnoremap <buffer> <BS>    <C-T>
	" }}}

	" diff highlighting {{{
	au FileType diff hi clear RedundantSpaces |
				\ hi DiffCol ctermbg=238 cterm=bold |
				\ match DiffCol /^[ +-]\([+-]\)\@!/
	" }}}

	" makefiles {{{
	au FileType make setlocal tabstop=8 shiftwidth=8 noexpandtab
	au FileType cmake setlocal tabstop=4 shiftwidth=4 expandtab
	" }}}

	" html/xml {{{
	au FileType html,xhtml,xml,xsd setlocal tabstop=2 shiftwidth=2 expandtab matchpairs+=<:>
	" }}}

	" ruby {{{
	au FileType ruby,yaml setlocal tabstop=2 shiftwidth=2 expandtab
	" }}}

	" python {{{
	au FileType python setlocal tabstop=4 shiftwidth=4 expandtab
	" }}}

	" auto-wrap text and text-like files {{{
	au BufNewFile,BufRead *.txt setfiletype text
	au FileType text,tex,plaintex,markdown setlocal formatoptions+=t | setlocal spell
	" }}}

	" Jamfiles {{{
	au BufNewFile,BufRead *.jam,Jamfile setlocal tabstop=2 shiftwidth=2 expandtab
	" }}}
augroup END " }}}

augroup AutoCloseWindowsIfLast " {{{
	autocmd!

	" automatically close nerdtree
    au bufenter *
	      \ if (winnr('$') == 1 && exists('b:NERDTreeType') && b:NERDTreeType == 'primary') |
	      \   quit |
	      \ endif

	" automatically close tagbar
    au bufenter *
	      \ if (winnr('$') == 1 && exists('b:Tagbar') && b:Tagbar == 'primary') |
	      \   quit |
	      \ endif

	" automatically close syntastic errors
	au bufenter *
	      \ if winnr('$') == 1 && getbufvar(winbufnr(winnr()), '&buftype') == 'quickfix' |
	      \   quit |
	      \ endif
" }}}

augroup OpenWindowWhereLastViewed " {{{
	autocmd!

	au BufWinLeave * mkview
	au BufWinEnter * silent loadview
" }}}

augroup FSwitchConfig " {{{
	autocmd!

	au BufEnter *.cc let b:fswitchdst='h,hh'
	au BufEnter *.h  let b:fswitchdst='c,cc,cpp,m'
augroup END " }}}

augroup VimCSS3Syntax
	autocmd!

	autocmd FileType css setlocal iskeyword+=-
augroup END

" }}}

" vim: set ts=2 sw=2 et
