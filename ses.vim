let SessionLoad = 1
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
inoremap <silent> <SNR>54_yrrecord =YRRecord3()
map  :CtrlPBuffer
nnoremap <silent>  :CtrlP
nnoremap  
nnoremap <NL> <NL>
nnoremap  
nnoremap  
nnoremap <silent>  :YRReplace '1', 'p'
nnoremap <silent>  :YRReplace '-1', 'P'
nnoremap  :call GotoFile("new")
nnoremap f :call GotoFile("new")
nmap 0 ^
vmap 0 ^
xnoremap <silent> P :YRPaste 'P', 'v'
nnoremap <silent> P :YRPaste 'P'
xmap S <Plug>VSurround
vmap Si S(i_f)
nmap \\u <Plug>CommentaryUndo:echomsg '\\ is deprecated. Use gc'
nmap \\\ <Plug>CommentaryLine:echomsg '\\ is deprecated. Use gc'
nmap \\ :echomsg '\\ is deprecated. Use gc'<Plug>Commentary
xmap \\ <Plug>Commentary:echomsg '\\ is deprecated. Use gc'
map \t :VimuxRunLastCommand
map \nf :NERDTreeFind
map \nb :NERDTreeFromBookmark 
map \nn :NERDTreeToggle
map \j :CtrlP
map \o :BufExplorer
map \r :VimuxPromptCommand
nnoremap \c :call CommentWithHashtags()
map \t\ :tabnext
map \tm :tabmove
map \tc :tabclose
map \to :tabonly
map \tn :tabnew
nnoremap \sv :source $MYVIMRC
nnoremap \ev :vsplit $MYVIMRC
map _lang :emenu ]LANGUAGES_GHC.
map _opt :emenu ]OPTIONS_GHC.
map _ie :call GHC_MkImportsExplicit()
map _ct :call GHC_CreateTagfile()
map _si :call GHC_ShowInfo()
map _t :call GHC_ShowType(0)
map _T :call GHC_ShowType(1)
map _iqm :call Import(1,1)
map _iq :call Import(0,1)
map _im :call Import(1,0)
map _i :call Import(0,0)
map _. :call Qualify()
map _?2 :call HaskellSearchEngine('hayoo!')
map _?1 :call HaskellSearchEngine('hoogle')
map _?? :let es=g:haskell_search_engines |echo "g:haskell_search_engines" |for e in keys(es) |echo e.' : '.es[e] |endfor
map _? :call Haddock()
map bd :bdelete
map bN :bprev
map bn :bnext
nmap cs <Plug>Csurround
nmap cgc <Plug>ChangeCommentary
xnoremap <silent> d :YRDeleteRange 'v'
nmap ds <Plug>Dsurround
nmap gx <Plug>NetrwBrowseX
nnoremap <silent> gp :YRPaste 'gp'
nnoremap <silent> gP :YRPaste 'gP'
xmap gS <Plug>VgSurround
nmap gcu <Plug>Commentary<Plug>Commentary
nmap gcc <Plug>CommentaryLine
omap gc <Plug>Commentary
nmap gc <Plug>Commentary
xmap gc <Plug>Commentary
nnoremap gf :call GotoFile("")
nmap j gj
vmap j gj
nmap k gk
vmap k gk
xnoremap <silent> p :YRPaste 'p', 'v'
nnoremap <silent> p :YRPaste 'p'
xnoremap <silent> x :YRDeleteRange 'v'
xnoremap <silent> y :YRYankRange 'v'
nmap ySS <Plug>YSsurround
nmap ySs <Plug>YSsurround
nmap yss <Plug>Yssurround
nmap yS <Plug>YSurround
nmap ys <Plug>Ysurround
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#NetrwBrowseX(expand("<cWORD>"),0)
nnoremap <silent> <SNR>54_yrrecord :call YRRecord3()
nnoremap <silent> <Plug>SurroundRepeat .
nmap <silent> <Plug>CommentaryUndo <Plug>Commentary<Plug>Commentary
imap S <Plug>ISurround
imap s <Plug>Isurround
imap  <Plug>Isurround
let &cpo=s:cpo_save
unlet s:cpo_save
set autoindent
set autoread
set backspace=eol,start,indent
set cmdheight=3
set completefunc=CompleteHaddock
set expandtab
set fileencodings=ucs-bom,utf-8,default,latin1
set helplang=en
set hidden
set history=700
set hlsearch
set ignorecase
set incsearch
set isfname=@,48-57,/,.,-,_,+,,,#,$,%,~,=,:
set laststatus=2
set nomodeline
set omnifunc=GHC_CompleteImports
set printoptions=paper:letter
set ruler
set runtimepath=~/.vim_runtime/sources/bufexplorer,~/.vim_runtime/sources/ctrlp.vim,~/.vim_runtime/sources/haskellmode-vim,~/.vim_runtime/sources/nerdtree,~/.vim_runtime/sources/open_file_under_cursor.vim,~/.vim_runtime/sources/peachpuff,~/.vim_runtime/sources/syntastic,~/.vim_runtime/sources/tlib,~/.vim_runtime/sources/vim-airline,~/.vim_runtime/sources/vim-clojure-static,~/.vim_runtime/sources/vim-commentary,~/.vim_runtime/sources/vim-markdown,~/.vim_runtime/sources/vim-repeat,~/.vim_runtime/sources/vim-surround,~/.vim_runtime/sources/vimux,~/.vim_runtime/sources/yankring,~/.vim,/var/lib/vim/addons,/usr/share/vim/vimfiles,/usr/share/vim/vim74,/usr/share/vim/vimfiles/after,/var/lib/vim/addons/after,~/.vim/after,~/.vim_runtime,~/.vim_runtime/sources/vim-markdown/after
set shellpipe=2>
set shiftround
set shiftwidth=2
set showtabline=2
set smartcase
set smartindent
set smarttab
set softtabstop=2
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set noswapfile
set tabline=%!airline#extensions#tabline#get()
set nowritebackup
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/Documents/SpiderOak/programming/haskell/daily_programmer_space
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +0 Main.hs
badd +0 Util.hs
badd +0 Help.hs
badd +0 readme.md
args Main.hs Util.hs Help.hs readme.md
edit Main.hs
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winheight=1 winwidth=1
argglobal
inoremap <buffer> $h #--- PH ----------------------------------------------FP2xi
setlocal keymap=
setlocal noarabic
setlocal autoindent
setlocal nobinary
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal nocindent
setlocal cinkeys=0{,0},0),:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=s1fl:{-,mb:-,ex:-},:--
setlocal commentstring=--\ %s
setlocal complete=.,w,b,u,t,i
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=CompleteHaddock
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal define=
setlocal dictionary=
setlocal nodiff
setlocal equalprg=
setlocal errorformat=%-Z\ %#,%W%f:%l:%c:\ Warning:\ %m,%E%f:%l:%c:\ %m,%E%>%f:%l:%c:,%+C\ \ %#%m,%W%>%f:%l:%c:,%+C\ \ %#%tarning:\ %m,
setlocal expandtab
if &filetype != 'haskell'
setlocal filetype=haskell
endif
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=croql
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=0
setlocal include=^import\\s*\\(qualified\\)\\?\\s*
setlocal includeexpr=substitute(v:fname,'\\.','/','g').'.'
setlocal indentexpr=
setlocal indentkeys=0{,0},:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=@,48-57,_,192-255
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal nolist
setlocal makeprg=/usr/bin/ghc\ \ -e\ :q\ %
setlocal matchpairs=(:),{:},[:]
setlocal nomodeline
setlocal modifiable
setlocal nrformats=octal,hex
setlocal nonumber
setlocal numberwidth=4
setlocal omnifunc=GHC_CompleteImports
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal shiftwidth=2
setlocal noshortname
setlocal smartindent
setlocal softtabstop=2
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal statusline=%!airline#statusline(1)
setlocal suffixesadd=hs,lhs,hsc
setlocal noswapfile
setlocal synmaxcol=3000
if &syntax != 'haskell'
setlocal syntax=haskell
endif
setlocal tabstop=8
setlocal tags=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let s:l = 1 - ((0 * winheight(0) + 25) / 50)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
tabnext 1
if exists('s:wipebuf')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToO
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
