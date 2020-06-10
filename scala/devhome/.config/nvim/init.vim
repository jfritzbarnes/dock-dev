set number
let mapleader = ","

" specific changes for golang
set autowrite
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

let g:go_fmt_command = "goimports"
let g:go_textobj_include_function_doc = 1
let g:go_addtags_transform = "camelcase"
let g:go_metalinter_autosave = 1
let g:go_auto_type_info = 1
let g:go_auto_sameids = 1
let g:deoplete#enable_at_startup = 1
let g:go_list_type = "quickfix"

autocmd FileType go nmap <leader>b <Plug>(go-build)
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>i <Plug>(go-info)
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif

filetype on
if !exists("autocommands_loaded")
  let autocommands_loaded = 1
  autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 expandtab

  " yaml
  " au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
  au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
endif

" some plugins use python; set up environment for them
"let g:python_host_prog = '/Users/fbarnes/.pyenv/versions/neovim2/bin/python'
"let g:python3_host_prog = '/Users/fbarnes/.pyenv/versions/neovim3/bin/python'
"let g:python3_host_prog = '/Users/fbarnes/.pyenv/versions/neovim37/bin/python'

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated
packloadall

call plug#begin(stdpath('data') . '/plugged')
Plug 'fatih/molokai'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" plugin options
let g:rehash256 = 1
let g:molokai_original = 1
colorscheme molokai


" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored
silent! helptags ALL

"call deoplete#custom#option('omni_patterns', {
"\ 'go': '[^. *\t]\.\w*',
"\})

