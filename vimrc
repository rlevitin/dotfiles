" Set runtime
runtime autoload/pathogen.vim
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
call pathogen#infect()
" basics
set t_Co=256			" set 256 color
set nocompatible		" use Vim defaults
set mouse=a				" make sure mouse is used in all cases.
set encoding=utf-8		" use utf-8 character encoding. (explicitly)
"colorscheme desert		" define syntax color scheme
set shortmess+=I		" disable the welcome screen
set complete+=k			" enable dictionary completion
set completeopt+=longest
set clipboard+=unnamed	" yank and copy to X clipboard
set backspace=indent,eol,start		   " full backspacing capabilities
set history=100			" 100 lines of command line history
set ruler				" ruler display in status line
set number				" show line numbers
if v:version >= 703
	set relativenumber		" show line number relative to cursor
endif
set showmode			" show mode at bottom of screen
set ww=<,>,[,]			" whichwrap -- left/right keys can traverse up/down
set cmdheight=2			" set the command height
set showmatch			" show matching brackets (),{},[]
set mat=5				" show matching brackets for 0.5 seconds

" wrap like other editors
set wrap				" word wrap
set textwidth=80		" 
set formatoptions=tcq	" automatic reformatting of paragraph as  you type
set lbr					" line break (doesn't work with set list enabled)
set display=lastline	" don't display @ with long paragraphs

" backup settings
set backup				" keep a backup file
set backupdir=/tmp		" backup dir
set directory=/tmp		" swap file directory

" tabs and indenting
set noexpandtab			  " insert spaces instead of tab chars
set tabstop=4			" a n-space tab width
set shiftwidth=4		" allows the use of < and > for VISUAL indenting
set softtabstop=4		" counts n spaces when DELETE or BCKSPCE is used
set autoindent			" auto indents next new line
" Shortcut to rapidly toggle `set list`
set list
nmap <leader>l :set list!<CR>
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬


" searching
set hlsearch			" highlight all search results
set incsearch			" increment search
set ignorecase			" case-insensitive search
set smartcase			" upper-case sensitive search

" Allow the creation of hidden buffers without watning
set hidden

" Spell checking
if v:version >= 700
	if has("gui_running")
		set spell
		setlocal spell spelllang=en_us
	endif
endif
" syntax highlighting
syntax on				" enable syntax highlighting

" Key Remapping for multiple windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" map <C-H> <C-w>H
" map <C-J> <C-w>J
" map <C-K> <C-w>K
" map <C-L> <C-w>L

" plug-in settings
if has("autocmd")
	filetype plugin on
	filetype indent on
	autocmd Filetype tex,latex :set grepprg=grep\ -nH\ $*
	autocmd Filetype tex,latex :set dictionary=~/.vim/dict/latex.dict
	autocmd Filetype tex,latex :set iskeyword+=:
	autocmd Filetype tex,latex :let g:Tex_ViewRule_pdf = 'zathura $*.pdf &'
	autocmd Filetype tex,latex :let g:Tex_CompileRule_pdf = 'latexmk $*.tex'
	autocmd Filetype tex,latex :let g:Tex_DefaultTargetFormat = 'pdf'
	let g:tex_flavor='latex'
	let g:tex_viewer={'app': 'zathura', 'target':'pdf'} 
	set background=dark
	let g:solarized_termcolor=256
	let g:solarized_termtrans=1
	" colorscheme solarized
	colorscheme vividchalk


	" Some tricks for mutt
	" F1 through F3 re-wraps paragraphs in useful ways
	augroup MUTT
		au BufRead ~/.mutt/temp/mutt* set spell " <-- vim 7 required
		au BufRead ~/.mutt/temp/mutt* nmap  <F1>	gqap
		au BufRead ~/.mutt/temp/mutt* nmap  <F2>	gqqj
		au BufRead ~/.mutt/temp/mutt* nmap  <F3>	kgqj
		au BufRead ~/.mutt/temp/mutt* map!  <F1>	<ESC>gqapi
		au BufRead ~/.mutt/temp/mutt* map!  <F2>	<ESC>gqqji
		au BufRead ~/.mutt/temp/mutt* map!  <F3>	<ESC>kgqji
	augroup END

	" Open odt in vim?
	au BufReadCmd *.docx,*.xlsx,*.pptx call zip#Browse(expand("<amatch>"))
	au BufReadCmd *.odt,*.ott,*.ods,*.ots,*.odp,*.otp,*.odg,*.otg call zip#Browse(expand("<amatch>"))

	" Syntax of these languages is fussy over tabs Vs spaces
	autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
	autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

	" Customisations based on house-style (arbitrary)
	autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
	autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
	autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab

	" Treat .rss files as XML
	autocmd BufNewFile,BufRead *.rss setfiletype xml

endif
