let g:startify_session_dir = '~/.config/nvim/session'

let g:startify_lists = [
          \ { 'type': 'files',     'header': ['   Files']            },
          \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
          \ { 'type': 'sessions',  'header': ['   Sessions']       },
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
          \ ]

let g:startify_bookmarks = [
            \ { 'c': '~/.config/bspwm/bspwmrc' },
            \ { 'i': '~/.config/nvim/init.vim' },
            \ { 'z': '~/.zshrc' },
            \ { 'o': '~/git_work/main_thesis' },
            \ { 'p': '~/git_work/personal_website' },
            \ { 's': '~/git_work/spinal-studies-rjah-site' },
            \ { 'g': '~/git_work' },
            \ '~/Pictures',
            \ ]

" automatically restart a session
let g:startify_session_autoload = 1
" Let Startify take care of buffers
let g:startify_session_delete_buffers = 1
" Similar to Vim-rooter
let g:startify_change_to_vcs_root = 1
" for Unicode
let g:startify_fortune_use_unicode = 1
" Automatically Update Sessions
let g:startify_session_persistence = 1
" Get rid of empy buffer on quit
let g:webdevicons_enable_startify = 1
