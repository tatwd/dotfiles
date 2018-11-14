" 设置行号
set number

" 语法高亮
syntax on

set encoding=utf-8

" 启用 256 色
" set t_Co=256

" 文件类型检查并载入对应的缩进规则
filetype indent on

set autoindent
"set cursorline

set nobackup
set noswapfile

" 设置插件
" 使用 vim-plug (https://github.com/junegunn/vim-plug) 管理插件
" 
" Windows 10 (must set `VIM`):
"     curl -fLo %VIM%/vimfiles/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" or
"     md %VIM%\vimfiles\autoload
"     $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
"     (New-Object Net.WebClient).DownloadFile(
"       $uri,
"       $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
"         "%VIM%\vimfiles\autoload\plug.vim"
"       )
"     )
"
" Unix:
"     curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
call plug#begin($VIM . '/vimfiles/plugged')

Plug 'tpope/vim-sensible'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'altercation/vim-colors-solarized'

Plug 'sheerun/vim-polyglot'

Plug 'editorconfig/editorconfig-vim'

Plug 'scrooloose/nerdtree'

call plug#end()

" 设置 airline-themes
let g:airline#extensions#tabline#enabled = 1

" 设置颜色主题
colorscheme slate
" let g:solarized_termcolors = 256
" if has('gui_running')
"  set background=light
" else
"  set background=dark
"endif
" colorscheme solarized
