if has('nvim')
	set rtp+=/usr/share/vim/vimfiles/
	set rtp+=~/.vim/
endif

let mapleader=","

scriptencoding utf-8
set encoding=utf-8

set mouse=a
set nosplitbelow nosplitright
set number relativenumber
syntax on
set foldmethod=indent
set nocompatible " for some reason i need this
set clipboard+=unnamedplus
set formatoptions-=cro
set cmdwinheight=1

" no Plugins for vscode neovim integration
if !exists('g:vscode')
	filetype off " for Vundle for some reason
	set rtp+=~/.vim/bundle/Vundle.vim
	call vundle#begin()

	" let Vundle manage Vundle, required
	Plugin 'VundleVim/Vundle.vim'

	"" Language pack ""
	Plugin 'sheerun/vim-polyglot'
	""

	"" C++ very good autocompletion ""
	Plugin 'valloric/youcompleteme'
	Plugin 'rdnetto/ycm-generator'
	""

	"" Python auto completion ""
	Plugin 'davidhalter/jedi-vim'
	""

	"" General auto completion ""
	" Plugin 'neoclide/coc.nvim'
	" Plugin 'Shougo/deoplete.nvim'
	" Plugin 'Shougo/neco-vim'
	""

	"" Arduino Programming
	Plugin 'stevearc/vim-arduino'
	Plugin 'sudar/vim-arduino-syntax'
	""

	" Plugin 'w0rp/ale'

	"" CMake stuff ""
	Plugin 'jansenm/vim-cmake'
	Plugin 'pboettch/vim-cmake-syntax'
	""

	"" Latex stuff ""
	Plugin 'lervag/vimtex'
	""

	"" GLSL Syntax ""
	Plugin 'tikhomirov/vim-glsl'
	""

	"" C++ Syntax ""
	Plugin 'octol/vim-cpp-enhanced-highlight'
	Plugin 'rhysd/vim-clang-format'
	" Plugin 'vim-syntastic/syntastic'
	""

	"" Usability improvements ""
	Plugin 'othree/xml.vim'
	Plugin 'tpope/vim-surround'
	Plugin 'tpope/vim-repeat'
	Plugin 'easymotion/vim-easymotion'
	Plugin 'psliwka/vim-smoothie'
	" Plugin 'dbakker/vim-adjustscroll'
	Plugin 'derekwyatt/vim-fswitch'
	Plugin 'tpope/vim-commentary'
	Plugin 'vim-airline/vim-airline'
	Plugin 'junegunn/fzf'
	Plugin 'junegunn/fzf.vim'
	Plugin 'scrooloose/nerdtree'
	Plugin 'mbbill/undotree'
	" Plugin 'sudo.vim'
	" Plugin 'sbdchd/neoformat'
	Plugin 'szw/vim-maximizer'
	Plugin 'rrethy/vim-hexokinase'
	""

	"" Colorscheme stuff ""
	" Plugin 'flazz/vim-colorschemes'
	Plugin 'arcticicestudio/nord-vim'
	" Plugin 'dylanaraps/wal'
	Plugin 'morhetz/gruvbox'
	Plugin 'vim-airline/vim-airline-themes'
	Plugin 'baskerville/bubblegum'
	" Plugin 'felixhummel/setcolors.vim'
	" Plugin 'vim-scripts/CycleColor'
	""

	"" tmux stuff ""
	Plugin 'christoomey/vim-tmux-navigator'
	Plugin 'benmills/vimux'
	Plugin 'tmux-plugins/vim-tmux-focus-events'
	Plugin 'tmux-plugins/vim-tmux'
	""

	"" Git stuff ""
	Plugin 'airblade/vim-gitgutter'
	Plugin 'tpope/vim-fugitive'
	Plugin 'junegunn/gv.vim'
	""

	call vundle#end()			" required
	filetype plugin indent on	" required
endif
filetype plugin indent on

set termguicolors

" keybindings
nnoremap fs :FSHere<CR>
nnoremap <C-N> :noh<CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap fzf :Files<CR>
nnoremap fzl :Lines<CR>
nnoremap ? :BLines<CR>
nnoremap fix :YcmCompleter FixIt<CR>
nnoremap <silent> <C-S> :w<CR>
inoremap <silent> <C-S> <esc>:w<CR>a
nnoremap L :bn<CR>
nnoremap H :bp<CR>
nnoremap Q :bd<CR>
inoremap (( ()<esc>i
inoremap (; ();<esc>hi
inoremap {{ {<esc>o}<esc>O
inoremap {; {<esc>o};<esc>O
inoremap <leader>ln <esc>:BLines<CR>a
nnoremap <leader>Sheadify 0f:Bdt:dw==$F)lDa;<esc>Istatic <esc>
inoremap <leader>headify <esc>0f:Bdt:dw==$F)lDa;<esc>^
nnoremap <leader>headify 0f:Bdt:dw==$F)lDa;<esc>
nnoremap <leader>stdstr va""tdastd::string(<esc>"tpa)
let @v='f,mcb"tywo(void) "tpA;`c@v'
nnoremap <leader>todofunc o// TODOk$F)b"tywo(void) "tpA;k^f(@v<CR>
" inoremap <leader>headify <esc>0Wdt:dw$F)C);<esc>==I
" nnoremap <leader>headify 0Wdt:dw$F)C);<esc>==I<esc>l
nnoremap <leader>snake viwb<esc>i<CR><esc>^d0ea<CR><esc>^d0k:s;\([A-Z]\);_\l\1;ge<CR>kJ$Jx:noh<CR>b
nnoremap : q:i
" nnoremap / q/i
xnoremap p "_dP

" vim easymotion
map 9 <Plug>(easymotion-prefix)
nmap s <Plug>(easymotion-overwin-f)

" Coc Bindings
" nmap <silent> gdf <Plug>(coc-definition)
" nmap <silent> gdc <Plug>(coc-declaration)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" Coc Denylist
" autocmd BufEnter *.c,*.cpp,*.h,*.hpp,*.rs CocDisable

" YCM Config
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_max_num_candidates = 50
let g:ycm_max_num_identifier_candidates = 10
let g:ycm_filetype_whitelist = {'cpp': 1, 'rust': 1, 'python': 1, 'xml': 1}
let g:ycm_error_symbol = '!'
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_extra_conf = "~/configs/ycm_global_conf.py"
set completeopt=menuone
if has("textprop")
	set completeopt+=popup
endif
let g:ycm_add_preview_to_completeopt = 0
autocmd! BufNewFile,BufRead *.vs,*.fs,*.gs set ft=glsl
highlight Pmenu ctermbg=1 ctermfg=15

" cursor type
if exists('$TMUX')
	let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>\<Esc>[6 q\<Esc>\\"
	let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>\<Esc>[2 q\<Esc>\\"
else
	let &t_SI = "\e[6 q"
	let &t_EI = "\e[2 q"
endif

" prettier splits
set background=dark
set fillchars+=vert:│
hi VertSplit cterm=NONE
hi StatusLine ctermbg=NONE ctermfg=NONE cterm=bold
set commentstring=/*%s*/

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" colorscheme
" colorscheme bubblegum-256-dark
colorscheme nord
let g:airline_theme='nord'
if $vim_colorscheme!=""
	" colorscheme $vim_colorscheme
	" let g:airline_theme=$vim_colorscheme
endif

" start scrolling if the cursor is too close to an edge
set scrolloff=6

" TEMPLATES
inoremap <leader>for <esc>Ifor( int i = 0; i < <esc>A; i++ ) {<CR>}<esc>O
inoremap <leader>cout <esc>Istd::cout << <esc>A << std::endl;
vnoremap <leader>cout yOstd::cout << <esc>pA << std::endl;

" rasi files syntax highlighting
autocmd BufNewFile,BufRead *.rasi setf css

" Special behaviour in *.tex files
autocmd BufEnter *.tex inoremap <buffer> <C-\> \textbackslash{}
autocmd BufEnter *.tex inoremap <buffer> "l \glqq{}
autocmd BufEnter *.tex inoremap <buffer> "r \grqq{}

" Return to the same line you left off at
augroup line_return
		au!
		au BufReadPost *
			\ if line("'\"") > 0 && line("'\"") <= line("$") |
			\	execute 'normal! g`"zvzz' |
			\ endif
	augroup END

" Remove trailing whitespaces
autocmd BufWritePre * %s/\s\+$//e

" Automatically source vimrc
autocmd BufWritePost *vimrc source %

" Show tab indents visually
set list lcs=tab:\|\ "
hi NonText ctermfg=8

" Use deoplete
let g:deoplete#enable_at_startup = 0

" Enable vimtex
let g:vimtex_enabled = 1
let g:vimtex_compiler_method = "latexmk"
let g:tex_flavor = "latex"
let g:vimtex_compiler_latexmk = {
	\ 'options' : [
	\		'-shell-escape',
	\		'-verbose',
	\		'-file-line-error',
	\		'-synctex=1',
	\		'-interaction=nonstopmode',
	\	],
	\}


" noremap <C-_> :noremap <kPlus> :res +1<CR> :noremap <kMinus> :res -1<CR>
function! SetVerticalResize()
	nnoremap <silent> + :vert res +1<CR>
	nnoremap <silent> - :vert res -1<CR>
endfunction
function! SetHorizontalResize()
	nnoremap <silent> + :res +1<CR>
	nnoremap <silent> - :res -1<CR>
endfunction

nnoremap <silent> <Bar> :call SetVerticalResize()<CR>
nnoremap <silent> _ :call SetHorizontalResize()<CR>

call SetHorizontalResize()

let g:python_recommended_style = 0

set smarttab tabstop=4 softtabstop=-1 noexpandtab shiftwidth=4
