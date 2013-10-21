" {{{ 插件管理
"/////////////////////////////////////////////////////////////////////////////
function! PluginManager()
    set nocompatible
    filetype off
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()

    Bundle 'gmarik/vundle'

    " ------------------------------------------------------------------
    " {{{ 界面类
    " ------------------------------------------------------------------
    " 颜色配色方案
    Bundle 'altercation/vim-colors-solarized'
    Bundle 'vim-scripts/Colour-Sampler-Pack'
    Bundle 'toupeira/vim-desertink'
    " 快捷浏览配色方案
    Bundle 'vim-scripts/Color-Scheme-Explorer'
    " 高亮Tag
    " Bundle 'magic-dot-files/TagHighlight'
    " 美化状态栏
    Bundle 'bling/vim-airline'
    Bundle 'Lokaltog/powerline-fonts'
    " }}}

    " ------------------------------------------------------------------
    " {{{ 工程管理
    " ------------------------------------------------------------------
    "" Vimprj的依赖项
    " Bundle 'vim-scripts/DfrankUtil'
    "" 管理工程相关的设置
    "Bundle 'vimprj'
    " 源代码管理
    Bundle 'tpope/vim-fugitive'
    "" 项目向导
    "Bundle 'PeterHo/VimAssist'
    " }}}

    " ------------------------------------------------------------------
    " {{{ 文件管理
    " ------------------------------------------------------------------
    " 目录树
    Bundle 'scrooloose/nerdtree'
    " 让nerdTree在最后一个buffer窗口关闭时，不让其缩放
    Bundle 'vim-scripts/bufkill.vim'
    " 查看Buf文件
    " Bundle 'bling/vim-bufferline'
    Bundle 'fholgado/minibufexpl.vim'
    " 搜索目录下的文件
    Bundle 'kien/ctrlp.vim'
    " }}}

    " ------------------------------------------------------------------
    " {{{ 快速编辑
    " ------------------------------------------------------------------
    " 快速注释代码
    Bundle 'scrooloose/nerdcommenter'
    " 自动括号
    Bundle 'jiangmiao/auto-pairs'
    " 代替snipMate
    Bundle 'SirVer/ultisnips'
    " 相当牛逼的补全,一旦拥有别无所求
    Bundle 'Valloric/YouCompleteMe'
    " 命令补全
    Bundle 'CmdlineComplete'
    " 快速移动光标
    Bundle 'Lokaltog/vim-easymotion'
    " }}}

    " ------------------------------------------------------------------
    " {{{ 编程辅助
    " ------------------------------------------------------------------
    "" 快速在.c和.h文件之间切换
    "Bundle 'a.vim'
    "" 代替taglist.vim
    "Bundle 'majutsushi/tagbar'
    "" 方便对齐代码
    "Bundle 'godlygeek/tabular'
    "" 文件中查找替换
    "Bundle 'vim-scripts/EasyGrep'
    "" 快速设置书签
    "Bundle 'vim-scripts/Vim-bookmark'
    "" TopCoder
    "Bundle 'vim-scripts/VimCoder.jar'
    "Bundle 'chazmcgarvey/vimcoder'
    " scrooloose / syntastic
    " gregsexton/gitv
    " repeat.vim 可能有用吧
    " }}}

    " ------------------------------------------------------------------
    " {{{ Python编程环境
    " ------------------------------------------------------------------
    "" Bundle 'klen/python-mode' " 确实用不了
    "" 补全
    ""Bundle 'vim-scripts/Pydiction'
    "" 代码折叠
    ""Bundle 'vim-scripts/python_fold'
    "" 代码检查
    "Bundle 'kevinw/pyflakes-vim'
    "" 调试
    "Bundle 'gotcha/vimpdb'
    " }}}

    " ------------------------------------------------------------------
    " {{{ Go编程环境
    " ------------------------------------------------------------------
    "Bundle 'jnwhiteh/vim-golang'
    "Bundle 'nsf/gocode'
    " }}}

    " ------------------------------------------------------------------
    " {{{ 其它
    " ------------------------------------------------------------------
    " Shell
    Bundle 'Shougo/vimproc.vim'
    Bundle 'Shougo/vimshell.vim'
    " 个人wiki
    Bundle 'vim-scripts/vimwiki'
    " }}}

    filetype on
endfunction
call PluginManager()
" }}}

" {{{ 定义常量
"/////////////////////////////////////////////////////////////////////////////
let IsLinux = has("UNIX")
let IsWin32 = has("Win32")

let mapleader = ";"
" }}}

" {{{ 常规设置
"/////////////////////////////////////////////////////////////////////////////
function! CommonSettings()
    " 不使用兼容vi的模式
    set nocompatible

    " 使用UNIX的鼠标标准
    behave xterm

    " 激活语法高亮
    syntax on

    " 启动文件类型探测,文件类型插件,缩进文件
    filetype plugin indent on

    " 不产生备份文件/交换文件
    set nobackup
    set nowritebackup
    set noswapfile

    " 保存命令和查找历史
    set history=50

    " 输入法
    autocmd InsertLeave * set imdisable
    autocmd InsertEnter * set noimdisable

    " 自动刷新文件
    set autoread " auto read same-file change ( better for vc/vim change )

    " 允许切换未保存的Buffer
    set hidden

    set clipboard=unnamedplus

    " <C-A>和<C-X>可以识别单个字母和十六进制数
    set nrformats=alpha,hex

    " 允许可视模式下的虚拟编辑
    set virtualedit=block

    " 中文文件支持
    set fileencodings=ucs-bom,utf-8,chinese,cp936
endfunction
call CommonSettings()
" }}}

" {{{ 界面/显示
"/////////////////////////////////////////////////////////////////////////////
function! GuiSettings()
    set number          " 显示行号
    set ruler           " 显示光标位置
    set laststatus=2    " 显示状态条
    set showcmd         " 显示未完成的命令
    set wildmenu        " 增强模式的命令行补全

    set guioptions-=T   " 不显示工具栏
    set guioptions-=r   " 不显示右边滚动条
    set guioptions-=L   " 不显示左边滚动条
    set guioptions-=m   " 不显示菜单栏
    set noshowmode      " 不显示当前模式,因为有PowerLine

    set shortmess=atI   " 各种缩略提示

    " set lazyredraw      " 推迟重画

    set scrolloff=3     " 提前3行就滚动屏幕

    set t_Co=256        " 终端颜色数

    if has("gui_running")
        set cursorline  " 高亮当前行
    endif

    set nowrap          " 禁止回绕行

    " 设置主题
    if has("gui_running")
        colorscheme desert_my
    else
        colorscheme zenburn
    endif

    " 设置字体
    set guifont=Sauce\ Code\ Powerline\ 10

    " 启动时最大化
    function! Maximize_Window()
        silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
    endfunction
    " if has("gui_running")
        " au GUIEnter * call Maximize_Window()
        " au VimEnter * call Maximize_Window()
    " endif
endfunction
call GuiSettings()
" }}}

" {{{ 查找/替换
"/////////////////////////////////////////////////////////////////////////////
function! FindAndReplaceSettings()
    " 增量搜索
    set incsearch

    " 自动判断搜索时是否忽略大小写
    set ignorecase smartcase

    " 高亮搜索结果
    set hlsearch
endfunction
call FindAndReplaceSettings()
" }}}

" {{{ 编程相关设置
"/////////////////////////////////////////////////////////////////////////////
function! ProgrammingSettings()
    " 缩进
    set autoindent              " 自动缩进
    set smartindent             " 聪明一点的缩进
    set cindent shiftwidth=4    " 使用C方式缩进,并且缩进空格数为4

    " 缩进设置,修改了 switch-case publish/private/protect etc...
    set cinoptions+=:0,g0,(0,us
    " 因为vimwiki取消 0#
    set cinkeys=0{,0},0),:,!^F,o,O,e

    " Tab
    set tabstop=8               " Tab长度为8个字符
    set softtabstop=4           " 但是看起来得是4个字符
    set expandtab               " 用空格代替Tab

    " 括号
    set showmatch               " 显示括号匹配
    set matchtime=0             " 设置匹配时间

    " 代码折叠
    set foldmethod=marker       " 通过标志折叠
    set foldmarker={{{,}}}      " 折叠标志
    set foldlevel=9999          " 不自动折叠

    " 补全
    set showfulltag             " 补全时显示标签名和查找模式

    " 不自动插入注释 (放到最后去,要不然会被后面的设置取消掉)
    " autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o
endfunction
call ProgrammingSettings()
" }}}

" {{{ 自定义命令/键映射
"/////////////////////////////////////////////////////////////////////////////
function! CommandOrKeymapSettings()
    " ------------------------------------------------------------------
    " {{{ 快速编辑
    " ------------------------------------------------------------------
    " 快捷修改 .vimrc
    map <silent> <leader>sv :source $MYVIMRC<cr>
    " map <silent> <leader>ev :e $MYVIMRC<cr>
    map <silent> <leader>ev :e $HOME/Dropbox/Settings/Vim/.vimrc<cr>
    map <silent> <leader>ei :e $HOME/Dropbox/Install/setup.sh<cr>
    map <silent> <leader>ea :e $HOME/Dropbox/Settings/awesome/rc.lua<cr>
    map <silent> <leader>ef :e $HOME/Dropbox/Settings/Firefox/.vimperatorrc<cr>
    autocmd! bufwritepost .vimrc nested source $MYVIMRC

    " 交换前后单词
    nnoremap <silent><leader>sw "_yiw:s/\(\%#\w\+\)\(\W\+\)\(\w\+\)/\3\2\1/<cr><c-o>

    " 加强的块缩进
    vnoremap < <gv
    vnoremap > >gv

    " 插入模式下的粘贴
    inoremap <C-v> <Esc>pa

    " 保存文件
    :nmap <C-S> <ESC>:w<cr>
    :imap <C-S> <ESC>:w<cr>

    " 普通模式下的 Backspace Space Enter 的行为
    nnoremap <CR> O<Esc>j
    nnoremap <S-CR> o<Esc>k
    nnoremap <Space> i<Space><Esc>l
    " nnoremap <Backspace> X
    " }}}

    " ------------------------------------------------------------------
    " {{{ 界面/窗口
    " ------------------------------------------------------------------
    " 清除查找高亮
    nnoremap <F8> :let @/=""<CR>

    " 切换窗口
    nnoremap <M-k> <C-W><Up>
    nnoremap <M-j> <C-W><Down>
    nnoremap <M-h> <C-W><Left>
    nnoremap <M-l> <C-W><Right>

    " 调整窗口大小
    nnoremap <silent><leader>wj 4<C-W><C-->
    nnoremap <silent><leader>wk 4<C-W><C-+>
    nnoremap <silent><leader>wh 4<C-W><C->>
    nnoremap <silent><leader>wl 4<C-W><C-<>

    " 快速分隔窗口
    command! V vsp

    " 关闭窗口
    nnoremap Q <C-W>c

    " 全屏
    let g:fullscreen = 0
    function! ToggleFullscreen()
        if g:fullscreen == 1
            let g:fullscreen = 0
            let mod = "remove"
        else
            let g:fullscreen = 1
            let mod = "add"
        endif
        call system("wmctrl -ir " . v:windowid . " -b " . mod . ",fullscreen")
    endfunction
    map <silent> <F11> :call ToggleFullscreen()<CR>
    " }}}

    " ------------------------------------------------------------------
    " {{{ 快速移动
    " ------------------------------------------------------------------
    " 一次3行
    noremap <C-e> 3<C-e>
    noremap <C-y> 3<C-y>

    " 插入模式下的光标移动
    inoremap <M-h> <Left>
    inoremap <M-j> <Down>
    inoremap <M-k> <Up>
    inoremap <M-l> <Right>

    " 用;;代替已被占用的;
    nnoremap ;; ;
    " }}}
endfunction
call CommandOrKeymapSettings()
" }}}

" {{{ 插件设置
"/////////////////////////////////////////////////////////////////////////////
function! PluginSettings()
    " ------------------------------------------------------------------
    " {{{ airline
    " ------------------------------------------------------------------
    " 使用PowerLine的字体
    let g:airline_powerline_fonts = 1
    " 显示总行数
    let g:airline_section_z = '%#__accent_bold#%l/%L%#__restore__#%3c'
    " 提示行尾空格和异常缩进
    let g:airline#extensions#whitespace#enabled = 1
    " 主题
    let g:airline_theme="powerlineish"
    set ttimeoutlen=50

    " " bufferline
    " let g:airline#extensions#bufferline#enabled = 1
    " let g:airline#extensions#bufferline#overwrite_variables = 1
    " " fugitive
    " let g:airline#extensions#branch#enabled = 1
    " let g:airline#extensions#branch#empty_message = ''
    " " syntastic
    " let g:airline#extensions#syntastic#enabled = 1
    " " tabbar
    " let g:airline#extensions#tagbar#enabled = 1
    " let g:airline#extensions#tagbar#flags = ''  "default
    " let g:airline#extensions#tagbar#flags = 'f'
    " let g:airline#extensions#tagbar#flags = 's'
    " let g:airline#extensions#tagbar#flags = 'p'
    " " vim-gitgutter/vim-signify
    " let g:airline#extensions#hunks#enabled = 1
    " let g:airline#extensions#hunks#non_zero_only = 0
    " let g:airline#extensions#hunks#hunk_symbols = ['+', '~', '-']
    " Ctrl-P
    let g:airline#extensions#ctrlp#color_template = 'insert'
    let g:airline#extensions#ctrlp#show_adjacent_modes = 1
    " " virtualenv
    " let g:airline#extensions#virtualenv#enabled = 1
    " " eclim
    " let g:airline#extensions#eclim#enabled = 1
    " }}}

    " ------------------------------------------------------------------
    " {{{ fugitive
    " ------------------------------------------------------------------
    command! -nargs=0 Gs :Gstatus
    command! -nargs=0 Gc :Gcommit
    " }}}

    " ------------------------------------------------------------------
    " {{{ NERD Tree
    " ------------------------------------------------------------------
    nmap <silent> <F5> :NERDTreeToggle<CR>
    let g:NERDChristmasTree=1
    let g:NERDTreeAutoCenter=1
    let g:NERDTreeBookmarksFile=$HOME.'/.vim/NerdBookmarks.txt'
    let g:NERDTreeMouseMode=2
    let g:NERDTreeShowBookmarks=1
    let g:NERDTreeChDirMode=2
    let g:NERDTreeIgnore=['\.pyc$', 'tags', '\.taghl$']

    " Prevent :bd inside NERDTree buffer
    au FileType nerdtree cnoreabbrev <buffer> bd <nop>
    au FileType nerdtree cnoreabbrev <buffer> BD <nop>
    " }}}

    " ------------------------------------------------------------------
    " {{{ bufkill
    " ------------------------------------------------------------------
    noremap <silent> <leader>z :bd<CR>
    " }}}

    " ------------------------------------------------------------------
    " {{{ MiniBufExpl
    " ------------------------------------------------------------------
    let g:miniBufExplorerAutoStart = 1
    let g:miniBufExplBuffersNeeded = 0
    let g:miniBufExplUseSingleClick = 1
    let g:miniBufExplShowBufNumbers = 1
    let g:miniBufExplCycleArround = 1
    nnoremap <silent><F6> :MBEToggle<cr>
    nnoremap <silent><leader>a :MBEToggleMRU<cr>
    nnoremap <silent><C-k> :MBEbn<cr>
    nnoremap <silent><C-j> :MBEbp<cr>
    nnoremap <silent><C-i> <C-^>
    " }}}

    " ------------------------------------------------------------------
    " {{{ bufferline
    " ------------------------------------------------------------------
    " let g:bufferline_active_buffer_left = '['
    " let g:bufferline_active_buffer_right = ']'
    " let g:bufferline_modified = '+'
    " let g:bufferline_show_bufnr = 1
    " noremap <silent> <leader>f :bp<CR>
    " noremap <silent> <leader>j :bn<CR>
    " }}}

    " ------------------------------------------------------------------
    " {{{ CtrlP
    " ------------------------------------------------------------------
    " 搜索最近文件
    nnoremap <leader>rr :CtrlPMRU<CR>
    " 搜索Buffer文件
    nnoremap <leader>bb :CtrlPBuffer<CR>

    let g:ctrlp_switch_buffer = 'Et'
    let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$\|.rvm$'
    let g:ctrlp_working_path_mode=0
    let g:ctrlp_max_height=15
    let g:ctrlp_mruf_max=500
    " }}}

    " ------------------------------------------------------------------
    " {{{ NERD Commenter
    " ------------------------------------------------------------------
    let g:NERDRemoveExtraSpaces=1
    let g:NERDSpaceDelims=1
    " }}}

    " ------------------------------------------------------------------
    " {{{ UltiSnips
    " ------------------------------------------------------------------
    let g:UltiSnipsUsePythonVersion = 2
    let g:UltiSnipsSnippetsDir="~/.vim/settings/UltiSnips"
    let g:UltiSnipsExpandTrigger="<c-j>"
    let g:UltiSnipsSnippetDirectories=["bundle/ultisnips/UltiSnips/", "settings/UltiSnips"]
    "let g:UltiSnipsJumpForwardTrigger="<tab>"
    "let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
    " }}}

    " ------------------------------------------------------------------
    " {{{ YouCompleteMe
    " ------------------------------------------------------------------
    nnoremap <leader>d :YcmCompleter GoToDefinitionElseDeclaration<CR>
    let g:ycm_complete_in_comments = 1
    let g:ycm_collect_identifiers_from_tags_files = 1
    let g:ycm_global_ycm_extra_conf = '~/.vim/settings/.ycm_extra_conf.py'
    let g:ycm_confirm_extra_conf = 0
    set completeopt=menu,longest
    " }}}

    " ------------------------------------------------------------------
    " {{{ EasyMotion
    " ------------------------------------------------------------------
    let g:EasyMotion_leader_key = 'm'
    " }}}

    " ------------------------------------------------------------------
    " {{{ vimshell
    " ------------------------------------------------------------------
    let g:vimshell_prompt_expr = 'escape(fnamemodify(getcwd(), ":~").">", "\\[]()?! ")." "'
    let g:vimshell_prompt_pattern = '^\%(\f\|\\.\)\+> '
    let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
    command! -nargs=0 S :VimShell
    " }}}

    " ------------------------------------------------------------------
    " {{{ Vimwiki
    " ------------------------------------------------------------------
    let g:vimwiki_use_mouse=1
    let wiki = {}
    let wiki.path = '~/Dropbox/vimwiki/'
    let wiki.path_html = '~/Dropbox/vimwiki/html/'
    let wiki.template_path = '~/Dropbox/vimwiki/'
    let wiki.template_default = 'default'
    let wiki.template_ext = '.tpl'
    let wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'c': 'c', 'bash': 'sh'}
    let g:vimwiki_list = [wiki]
    let g:vimwiki_hl_cb_checked = 1
    let g:vimwiki_folding = 'expr'
    let g:vimwiki_html_header_numbering = 0
    let g:vimwiki_list_ignore_newline = 0
    nmap <silent> <leader>wah :VimwikiAll2HTML<cr>
    nmap <silent> <leader>tt :e $HOME/Dropbox/vimwiki/计划/计划.wiki<cr>
    " }}}

    "/////////////////////////////////////////////////////////////////////////////
    " Tagbar
    "/////////////////////////////////////////////////////////////////////////////
    nnoremap <silent> <F4> :TagbarToggle<CR>
    let g:tagbar_singleclick=1




    "/////////////////////////////////////////////////////////////////////////////
    " TagHighlight
    "/////////////////////////////////////////////////////////////////////////////
    nnoremap <silent> <F12> :UpdateTypesFile<CR>


    "/////////////////////////////////////////////////////////////////////////////
    " Cscope
    "/////////////////////////////////////////////////////////////////////////////
    ":set cscopequickfix=s-,c-,d-,i-,t-,e-
    set cst
    set csto=1

    nmap <C-C>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-C>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-C>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-C>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-C>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-C>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-C>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-C>d :cs find d <C-R>=expand("<cword>")<CR><CR>

    nmap <C-C><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-C><C-G> :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-C><C-C> :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-C><C-T> :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-C><C-E> :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-C><C-F> :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-C><C-I> :cs find i <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-C><C-D> :cs find d <C-R>=expand("<cword>")<CR><CR>



    "/////////////////////////////////////////////////////////////////////////////
    " Vim Bookmark
    "/////////////////////////////////////////////////////////////////////////////
    let g:vbookmark_bookmarkSaveFile = $HOME . '/.vim/.vimbookmark'
    nnoremap <silent> <F2> :VbookmarkNext<CR>


    "/////////////////////////////////////////////////////////////////////////////
    " vimprj
    "/////////////////////////////////////////////////////////////////////////////
"    let g:vimprj_changeCurDirIfVimprjFound=0

"    function! <SID>SetMainDefaults()
"        " your default options goes here!
"        set tags=./.vimprj/tags
"    endfunction
"
"    call <SID>SetMainDefaults()
"
"    " initialize vimprj plugin
"    call vimprj#init()
"
"    " define a hook
"    function! g:vimprj#dHooks['SetDefaultOptions']['main_options'](dParams)
"        call <SID>SetMainDefaults()
"    endfunction


    "/////////////////////////////////////////////////////////////////////////////
    " man
    "/////////////////////////////////////////////////////////////////////////////
    :source $VIMRUNTIME/ftplugin/man.vim
    nmap K :Man 3 <cword><CR>


    "/////////////////////////////////////////////////////////////////////////////
    " Pydiction
    "/////////////////////////////////////////////////////////////////////////////
    "let g:pydiction_location = $HOME . '/.vim/bundle/Pydiction/complete-dict'
    "let g:pydiction_menu_height = 20
    "let &dictionary = g:pydiction_location



    "/////////////////////////////////////////////////////////////////////////////
    " VimOrganizer
    "/////////////////////////////////////////////////////////////////////////////
    au! BufRead,BufWrite,BufWritePost,BufNewFile *.org
    au BufEnter *.org call org#SetOrgFileType()
    let g:org_command_for_emacsclient = 'emacsclient'


    "/////////////////////////////////////////////////////////////////////////////
    " vim-golang
    "/////////////////////////////////////////////////////////////////////////////
    filetype off
    filetype plugin indent off
    set runtimepath+=$HOME/.vim/bundle/vim-golang
    filetype plugin indent on
    syntax on
endfunction
call PluginSettings()
" }}}

autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o


finish

" 显示总行数

" programming related
"set tags+=./tags,./../tags,./**/tags,tags,~/.vim/systags " which tags files CTRL-] will find

set viminfo+=! " make sure it can save viminfo

" diff

" 窗口独占切换

" Update
:nmap <M-u> :call Update()<CR><CR>

" make
map <F10> :M<CR>
