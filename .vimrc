" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"Plugin 'SirVer/ultisnips'
Plugin 'dracula/vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'gmarik/Vundle.vim'
Plugin 'honza/vim-snippets'
Plugin 'idanarye/vim-dutyl'
Plugin 'johnsyweb/vim-makeshift'
Plugin 'junegunn/fzf.vim'
Plugin 'ludovicchabant/vim-lawrencium'
Plugin 'majutsushi/tagbar'
Plugin 'markvincze/panda-vim'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'preservim/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-scripts/a.vim'
Plugin 'zah/nim.vim'
Plugin 'RRethy/vim-illuminate'
Plugin 'habamax/vim-asciidoctor'
Plugin 'will133/vim-dirdiff'
Plugin 'mjakl/vim-asciidoc'
call vundle#end()

" tagbar:
let g:tagbar_type_d = {
   \ 'ctagstype' : 'd',
   \ 'kinds'     : [
   \ 'c:classes:1:1',
   \ 'f:functions:1:1',
   \ 'T:template:1:1',
   \ 'g:enums:1:1',
   \ 'e:enumerators:0:0',
   \ 'u:unions:1:1',
   \ 's:structs:1:1',
   \ 'v:variables:1:0',
   \ 'i:interfaces:1:1',
   \ 'm:members',
   \ 'a:alias'
   \ ],
   \'sro': '.',
   \ 'kind2scope' : {
   \ 'c' : 'class',
   \ 'g' : 'enum',
   \ 's' : 'struct',
   \ 'u' : 'union',
   \ 'T' : 'template',
   \},
   \ 'scope2kind' : {
   \ 'enum'      : 'g',
   \ 'class'     : 'c',
   \ 'struct'    : 's',
   \ 'union'     : 'u',
   \ 'template'  : 'T',
   \ },
   \ 'ctagsbin' : 'dscanner',
   \ 'ctagsargs' : ['--ctags']
\ }

syn on
colo hotpot
if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end
set t_Co=256
set mouse=n
set autoindent
set autoread
set cinoptions=:0,p0,t0,(0,g0,N-s
set cinwords=if,else,while,do,for,switch,case
set confirm
"set diffopt+=iwhite
set nocompatible
set formatoptions=tcqr
set hlsearch
set km=startsel
set restorescreen
set ruler
set showcmd
"set slm=mouse,key
set smartcase
set wildmode=longest,full
set cin
set tw=0 sw=4 ts=4 sts=4 et
set nocp incsearch
set scrolloff=1
set wrap
set tags=tags
set foldlevel=1
set tabpagemax=100
set backspace=indent,eol,start
set sessionoptions-=options
set encoding=utf-8
set fileencoding=utf-8
if &diff
    set noreadonly
endif
filetype plugin on
filetype plugin indent on
au BufNewFile,BufRead *.ad set filetype=adoc
au BufNewFile,BufRead *.di set filetype=d
au BufNewFile,BufRead *gdb* set filetype=gdb
au BufNewFile,BufRead *.val set filetype=valgrind
au BufNewFile,BufRead *.st set filetype=strace
au BufNewFile,BufRead *.jelly set filetype=html
au BufRead,BufNewFile *.proto set filetype=proto
"au FileType xml exe ":silent !xmllint --format --recover - 2>/dev/null"
autocmd BufNewFile,BufRead *.json set ft=javascript
autocmd BufRead,BufNewFile *.log set syntax=log
autocmd BufRead,BufNewFile *.md setlocal textwidth=120
autocmd BufRead,BufNewFile COMMIT_EDITMSG setlocal textwidth=80 spell
autocmd BufRead,BufNewFile *.ad setlocal textwidth=100

if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endi
"map <F7> exe ":silent '<,'>!xmllint --format --recover - 2>/dev/null"

if has('gui_running')
    colo ir-black
    set gfn=Monospace\ 10
    set go=caeim
    set gcr+=a:blinkon0
    set nowrap
    set mouse=
endif


" For clang complete
"let g:clang_use_library = 1
"let g:clang_user_options = '-std=c++11'
"let g:clang_auto_select = 2

" Syntax highlight
let g:cpp_class_scope_highlight = 1

" For ultisnips
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
""""

" Other
let g:molokai_original = 1
let g:rehash256 = 1
set background=dark
"let g:pydiction_location='/home/arun/.vim/pydiction-1.2/complete-dict'
let g:DirDiffExcludes = "*.git,*.class,*.exe,.*.swp,*.hg,*.o,*.so"
let g:DirDiffIgnore = "Id:,Revision:,Date:"
let g:DoxygenToolkit_commentType = "C++"
let g:DirDiffSort = 1
let g:DirDiffWindowSize = 7
let g:DirDiffIgnoreCase = 0
let g:DirDiffDynamicDiffText = 0
let g:DirDiffTextFiles = "Files "
let g:DirDiffTextAnd = " and "
let g:DirDiffTextDiffer = " differ"
let g:DirDiffTextOnlyIn = "Only in "
let g:DoxygenToolkit_briefTag_pre = ""
let g:load_doxygen_syntax=1

" YCM
let g:ycm_confirm_extra_conf = 0

set omnifunc=syntaxcomplete#Complete " override built-in C omnicomplete with C++ OmniCppComplete plugin
let OmniCpp_GlobalScopeSearch   = 1
let OmniCpp_DisplayMode         = 1
let OmniCpp_ShowScopeInAbbr     = 0 "do not show namespace in pop-up
let OmniCpp_ShowPrototypeInAbbr = 1 "show prototype in pop-up
let OmniCpp_ShowAccess          = 1 "show access in pop-up
let OmniCpp_SelectFirstItem     = 1 "select first item in pop-up
set completeopt=menuone,menu,longest

function! FormatCppOnSave()
    let l:formatdiff = 1
    py3f /usr/share/vim/addons/syntax/clang-format.py
endfunction
function! FormatDOnSave()
    let l:formatdiff = 1
    !dfmt .
endfunction

"autocmd BufWritePre *.h,*.cc,*.cpp,*.hpp call FormatCppOnSave()
"autocmd BufWritePre *.d,*.di call FormatDOnSave()

fun! ShowFuncName()
    let lnum = line(".")
    let col = col(".")
    echohl ModeMsg
    echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
    echohl None
    call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
nmap \ :call ShowFuncName()<cr>

" Custom key maps
map <C-@> <C-Space>
map <C-Space> <Esc>:x<cr>
imap <C-@> <C-Space>
imap <C-Space> <Esc>:x<cr>
nmap <C-i> gt
nmap <S-Tab> gT
map  <C-q> :diffoff!<cr>
map  <C-s> <Esc>:wa<cr>
imap <C-s> <Esc>:wa<cr>
map  <C-Space> <Esc>:x<cr>
map  <C-d> :diffthis<cr>
map tt :TagbarToggle<cr>
map tr :NERDTreeToggle<cr>
map Y gqgq
map Q i<cr><esc>l
map <F1> :w<cr>:call g:ClangUpdateQuickFix()<cr>co
map <F2> :wn<cr>
nnoremap <F7> :se nu!<cr>
map <F5> :make clean && make -j4<cr><cr>
map <F6> :tabe<space>
"map <F7> :make clean && make -j10<cr><cr><cr>
map <F7> :se nu!<cr>
map <F8> :se paste!<cr>
map <F9> :%s,\s\+$,,<cr>
map <F10> :se wrap!<cr>
map <F11> :%!xxd<cr>
map <F12> :%!xxd -r<cr>
map cn :cnext<cr>
map cp :cprev<cr>
map co :cope<cr><c-w>J
map cc :ccl<cr>
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
nmap <Esc>h <C-w>h
nmap <Esc>j <C-w>j
nmap <Esc>k <C-w>k
nmap <Esc>l <C-w>l
imap <C-a> <C-o>I
imap <C-e> <C-o>A
imap <C-k> <C-o>D
imap <C-y> <C-o>p
imap <C-s> <Esc>:wa<cr>
imap <C-Space> <Esc>:x<cr>

set <M-f>=f
set <M-b>=b
imap <M-b> <C-o>b
imap <M-f> <C-o>w

nnoremap <F4> :<C-U>MakeshiftBuild<CR>
nnoremap <F5> :<C-U>MakeshiftBuild check<CR>

" Disable arrow keys
"noremap <up> <esc>
"inoremap <up> <nop>
"noremap <down> <esc>
"inoremap <down> <nop>
"noremap <right> <esc>
"inoremap <right> <nop>
"noremap <left> <esc>
"inoremap <left> <nop>

" Special settings to include date and my name in TODO FIXME and comments
"ab cO Arun \|<esc>:r!date +\%Y-\%m-\%d\ \\|<esc>kJA
"ab FIXME FIXME: Arun \|<esc>:r!date +\%Y-\%m-\%d\ \\|<esc>kJA
"ab TODO TODO: Arun \|<esc>:r!date +\%Y-\%m-\%d\ \\|<esc>kJA
ab cO Arun \|<esc>:r!date +\%d\%b\%y\ \\|<esc>kJA
ab FIXME FIXME: Arun \|<esc>:r!date +\%d\%b\%y\ \\|<esc>kJA
ab TODO TODO: Arun \|<esc>:r!date +\%d\%b\%y\ \\|<esc>kJA
ab aU @author Arun Chandrasekaran <arun.chandrasekaran@necam.com>
cnoreabbrev W w
cnoreabbrev m make
cnoreabbrev qm !qmake mode=debug
