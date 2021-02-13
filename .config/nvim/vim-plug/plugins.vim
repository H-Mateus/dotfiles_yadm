" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    " File Explorer
    Plug 'scrooloose/NERDTree'
    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'
    " Themes
    Plug 'joshdick/onedark.vim'
    " Intelisense - Stable version of coc
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Status line
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    " Ranger
    Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}
    " FZF
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'airblade/vim-rooter'
    " Colorizer - shows hex colours
    Plug 'norcalli/nvim-colorizer.lua'
    " Rainbow parentheses
    Plug 'junegunn/rainbow_parentheses.vim'
    " Startify - project management
    Plug 'mhinz/vim-startify'
    " Git intergration
    Plug 'mhinz/vim-signify'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb'
    Plug 'junegunn/gv.vim'
    " Sneak
    Plug 'justinmk/vim-sneak'
    " Which key - prompt to show keys
    Plug 'liuchengxu/vim-which-key'
    " Floatterm - ternimal for quick commands in vim
    Plug 'voldikss/vim-floaterm'
    " Snippets with Coc
    Plug 'honza/vim-snippets'
    "Plug 'SirVer/ultisnips'
    " Intuitive buffer closing
    Plug 'moll/vim-bbye'
    " Rmarkdown support
    Plug 'vim-pandoc/vim-pandoc'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    "Plug 'vim-pandoc/vim-rmarkdown'
    " Codi - live code evaluation
    Plug 'metakirby5/codi.vim'
    " Better Comments
    Plug 'tpope/vim-commentary'
    " Text Navigation
    Plug 'unblevable/quick-scope'
    " Nvim-R - RStudio like set up - R console, etc
    Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}
    " for other languages
    Plug 'jalvesaq/vimcmdline'
    " send commands to REPL
    "Plug 'KKPMW/vim-sendtowindow'        
    "Plug 'jpalardy/vim-slime'
    "Plug 'christoomey/vim-tmux-navigator'


call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
