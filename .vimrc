
if executable('ag')
	let g:ackprg = 'ag --vimgrep'
endif

" Кодировка vimrc - utf-8
scriptencoding utf-8

" Add the virtualenv's site-packages to vim path
if has('python')
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
endif

" менеджер пакетов
set nocompatible
let mapleader = "'"
call pathogen#infect()
call pathogen#helptags()

if jedi#init_python()
  function! s:jedi_auto_force_py_version() abort
    let major_version = pyenv#python#get_internal_major_version()
    call jedi#force_py_version(major_version)
  endfunction
  augroup vim-pyenv-custom-augroup
    autocmd! *
    autocmd User vim-pyenv-activate-post   call s:jedi_auto_force_py_version()
    autocmd User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
  augroup END
endif

" И вообще, юникод - это прогрессивненько
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
" ...в отличие, например, от
set ffs=unix,dos,mac
set fencs=utf-8,cp1251,koi8-r,ucs-2,cp866

" запоминать историю undo между перезапусками
set undodir=~/.vim/undodir/
set undofile

" Я не evim
if v:progname =~? "evim"
	finish
endif

" пути для gf (open file at cursor)
let &path.="/usr/include,/usr/include/gstreamer-1.0"

filetype plugin indent on

autocmd BufNewFile,BufRead *.jinja2,*.j2,*.jinja set ft=jinja

" Внешний вид {
	syntax on " подсветка синтаксиса
	set shortmess+=I " отключаем детей Уганды
	" отключаем звуковой и визуальный сигналы
	if has("gui_running")
		set novisualbell
	else
		set visualbell
	endif

	set ruler		" всегда показывать курсор
	set showcmd		" показывать недописанные команды
	set cursorline " подсвечивать текущую строку
	
	set nu " нумерация строк

	" Устанавливаем ширину текста в 80 символов,
	" символы начиная с 81-го
	autocmd FileType text setlocal textwidth=80
	if exists('+colorcolumn')
		au FileType c,cc,cpp,cxx,h,hpp,hxx,cuda,sh,python au BufWinEnter * setlocal colorcolumn=80
	else
		au FileType c,cc,cpp,cxx,h,hpp,hxx,cuda,sh,python au BufWinEnter * let w:m1=matchadd('ErrorMsg', '\%>80v.\+', -1)
	endif
	au FileType lua,markdown,jinja,html setl noet!
	" отключить автоматический перенос строк
	set formatoptions-=tc
	autocmd Syntax * call matchadd('Todo', "HACK")

	set nowrap " не переносить длинные строки
	set wildmenu " дикое меню :3
	set foldmethod=indent " включаем фолдинг (сворачивание участков кода)
	set nofoldenable
	set fdm=indent " Сворачивание по отступам
	set gfn=MonofurForPowerline\ Nerd\ Font\ 14,Monofur\ for\ Powerline\ 14,Monaco\ 10,DejaVu\ Sans\ Mono\ 10

	set stal=2 " постоянно выводим строку с табами
	
	" Отображаем табуляции и хвостовые пробелы
	set list
	set listchars=tab:→→,trail:⋅

	" Cтрока состояния
	set laststatus=2

	"set statusline=%<%f%h%m%r\ \[%{&encoding}]\ \|\ Line:\ %3l/%L[%3p%%]\ Col:\ %2c\ \|\ %{Tlist_Get_Tagname_By_Line()}

	" Plugin minibufexpl {
		let g:miniBufExplorerMoreThanOne=2
		let g:miniBufExplUseSingleClick=1
		let g:miniBufExplModSelTarget=1
	" }

	if has ("gui_running")
		"антиалиасинг для шревтоф
		set antialias
		"прячем курсор
		set mousehide
		"Так не выводятся ненужные escape последовательности в :shell
		set noguipty
	endif

" }

" Скин {
	if &term=~'linux'
		" defaults just ok
	else
		set t_Co=256
		colorscheme zenburn
	endif
" }

" Поведение {
	" Не выгружать буфер, когда переключаемся на другой.
	" Это позволяет редактировать несколько файлов в один и тот же момент без
	" необходимости сохранения каждый раз когда переключаешься между ними
	set hidden
	set confirm " спрашивать подтверждение, вместо ругани при закрытии несохранённого буфера
	set splitright " новое окно появляется справа
	set autowrite " автоматом записывать изменения в файл при переходе к другому файлу

	" разрешить мышку
	set mouse=a
	set mousemodel=popup

	" переходить к предыдущей позиции при переоткрытии файла
	if has("autocmd")
	  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
	endif

	" использовать иксовый буфер как основной, если vim собран с подержкой
	" clipboard
	set clipboard=unnamed
	" При копировании добавить в иксовый буфер (итак добавляется)
"	nmap yy yy:silent .w !xclip<CR>
"	vmap y y:silent '<,'> w !xclip<CR>

	set autochdir " переходить в текущую директорию файла
	set nobackup		" не делать богомерзкие *~ бэкапы
	set directory=~/.vim/swap " хранить swap в отдельном каталоге
	set sessionoptions=curdir,buffers,tabpages " что сохранять в сесссии
	set noex " не читаем файл конфигурации из текущей директории
	set history=50		" хранить 50 строк истории
	set backspace=indent,eol,start " бэкспейс стирает всё

	" таб
	set tabstop=4
	set softtabstop=4
	set shiftwidth=4
	set cindent
	"set autoindent " автоидентация?..

	" Теперь нет необходимости передвигать курсор к краю экрана, чтобы подняться в режиме редактирования
	set scrolljump=7
	" Теперь нет необходимости передвигать курсор к краю экрана, чтобы опуститься в режиме редактирования
	set scrolloff=7

	function! UPDATE_TAGS()
		let _f_ = expand("%:p")
		let _cmd_ = 'ctags -R --languages=c,c++,python --c++-kinds=+pl --python-kinds=-iv --fields=+ilaS --extra=+q --sort=yes ' . _f_
		let _resp = system(_cmd_)
		unlet _cmd_
		unlet _f_
		unlet _resp
	endfunction
	autocmd BufWritePost *.cpp,*.hpp,*.c,*.h,*.cxx,*.hxx call UPDATE_TAGS() " автоматически обновляем ctags при сохранении буфера

	" делаем из vim 'редактор реального времени'
	set updatetime=0 " Время обновления окна = 0 миллисекунд
	"set lz " ленивая перерисовка экрана при выполнении скриптов
	set ttyfast " коннект с терминалом быстрый
" }

" Поиск {
	set incsearch		" инкрементальный поиск
	set hlsearch " подсвечивать строчки при поиске
	set ignorecase " регистронезависимо
	set smartcase " регистрозависимо, если ищем КАПС
" }

" Plugin sessionman {
	let g:sessionman_save_on_exit=1
" }

" Plugin NERDTree {
	"autocmd VimEnter * NERDTree
	"autocmd VimEnter * wincmd p
	let NERDTreeIgnore=['\.pyc$', '\.pyo$', '\.pyd$']
" }

" Plugin Syntastic {
	if has("gui_running")
		let g:syntastic_check_on_open=1
		let g:syntastic_echo_current_error=0
		map <C-y> :SyntasticToggleMode<cr>
		imap <C-y> <esc>:SyntasticToggleMode<cr>a
	else
		let g:syntastic_check_on_open=0
		let g:syntastic_echo_current_error=1
		map <C-y> :SyntasticCheck<cr>
		imap <C-y> <esc>:SyntasticCheck<cr>a
	endif
	let g:syntastic_enable_signs=1
	let g:syntastic_enable_highlighting=1
	let g:syntastic_cpp_compiler = 'clang++'
	let g:syntastic_cpp_include_dirs=['.', '..', '../include', 'include', '/usr/include/gstreamer-1.0', '/usr/lib64/gstreamer-1.0/include', '/usr/include/opencv', '/usr/include/qt5', '/usr/include/qt5/QtCore', '/usr/include/qt5/QtGui', '/usr/include/qt5/QtWidgets']
	let g:syntastic_c_include_dirs=g:syntastic_cpp_include_dirs
	let g:syntastic_cpp_compiler_options='-std=c++0x -fPIC'
	let g:syntastic_python_python_exec = 'python3'
	let g:syntastic_stl_format = "%E{ERR  %fe (%e total)}%B{, }%W{WARN  %fw (%w total)}"
" }

" Plugin clang_complete {
	let g:clang_complete_macros = 1

	" автоматически открывать и закрывать окошко предпросмотра
	au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

	set completeopt=menu,menuone,longest  " всплывающая менюшка
	au FileType python setlocal completeopt-=longest  " fix this: https://github.com/davidhalter/jedi-vim/issues/429

	set complete=.,t,b,k " порядок автодополнения: словарь текущего буфера, c-тэги, словарь всех буферов, глобальный словарь
" }

" Plugin airline {
	if has("gui_running")
		let g:airline_powerline_fonts = 1
	endif
	let g:airline_detect_whitespace=2
	let g:airline_theme="zenburn"
	set ttimeoutlen=50
	let g:airline_section_c = '%t%m'
	let g:airline_section_x = '%{airline#extensions#tagbar#currenttag()}'
	let g:airline_section_warning = ''
	let g:airline#extensions#po#displayed_limit = 11
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tabline#show_tabs = 0
	let g:airline#extensions#tabline#buffers_label = ' '
	let g:airline#extensions#tabline#buffer_nr_show = 1
" }

" Plugin buftabline {
	let g:buftabline_numbers = 1
	let g:buftabline_indicators = 1
	let g:buftabline_separators = 1
" }

" Plugin tagbar {
	let g:tagbar_sort = 0
	let g:tagbar_compact = 1
	let g:tagbar_autoshowtag = 1
" }

" Plugin supertab {
	let g:SuperTabDefaultCompletionType = "<c-n>"
	autocmd FileType *
	  \ if &omnifunc != '' |
	  \   call SuperTabChain(&omnifunc, "<c-x><c-o><c-n>") |
	  \ endif
" }

" Plugin jedi {
	let g:jedi#use_splits_not_buffers = "bottom"
	let g:jedi#show_call_signatures = "1"
	let g:jedi#completions_command = ""  " we're using supertab for this
	let g:jedi#popup_select_first = 0
" }

" Plugin CtrlP {
	"let g:ctrlp_user_command = 'find . -type f -exec /bin/grep -Iq . {} \; -and -print' " shows NO ENTRIES :(
	let g:ctrlp_root_markers = ['CMakeLists.txt', 'requirements.txt', 'setup.py']
	let g:ctrlp_clear_cache_on_exit = 0
	let g:ctrlp_show_hidden = 1
	let g:ctrlp_open_new_file = 'r'
	let g:ctrlp_line_prefix = '→ '
	let g:ctrlp_extensions = ['mixed']
	let g:ctrlp_cmd = 'CtrlPMixed'
	let g:airline#extensions#ctrlp#show_adjacent_modes = 0
	set wildignore+=*.pyc,*.d,*.o
" }

" Горячие ключи {

	" возможность использовать команды при русской раскладке
	" VIM CANNOT INTO UTF8  *coolface.jpg*
	"set langmap=Ж:,йq,цw,уe,кr,еt,нy,гu,шi,щo,зp,х[,ъ],фa,ыs,вd,аf,пg,рh,оj,лk,дl,э',яz,чx,сc,мv,иb,тn,ьm,б\,,ю.,ё`
	set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>

	nnoremap <leader>s :vs<cr>
	nnoremap <leader><space> :noh<cr>
	nnoremap ; :

	set wak=yes " используем ALT как обычно, а не для вызова пункта меню

	set wcm=<Tab>

	" переключение буферов
	noremap <C-down> :bprev<CR>
	noremap <C-up> :bnext<CR>
	inoremap <C-down> <Esc>:bprev<CR>
	inoremap <C-up> <Esc>:bnext<CR>
	inoremap <F1> <Nop>
	nnoremap <F1> <Nop>
	vnoremap <F1> <Nop>
	" сохранение всех буферов
	imap <F2> <Esc>:wa<CR>a
	nmap <F2> :wa<CR>
	" переключение между хедером и реализацией
	map <F3> :A<CR>
	imap <F3> <Esc>:A<CR>a
	" Поиск
	imap <F4> <Esc>:Ack!<Space>
	nmap <F4> :Ack!<Space>
	" запуск
"	map <F5> :! ./%< <CR> 	
	map <F6> :Tagbar<CR>
	" предыдущая/следующая ошибка
	map <F7>  :cp<CR>
	map <F8>  :cn<CR>
	map <F9> :ccl<CR>
	" сборка с сохранением и с мэйк-файлом
	function! Make ()
		exe ":cclose"
		exe ":update"
		exe "make"
		:redraw! " открыть окно с ошибками, если нужно
		exe     ":botright cwindow"
	endfunction " Make
	function! BindF5_C()
		"http://habrahabr.ru/blogs/vim/40369/
	    if filereadable("Makefile")
		    set makeprg=make\ -f\ Makefile
			"map! <F5> :call Make()<CR>:call C_HlMessage()<CR>
			map <F5> :call Make()<CR>
			imap <F5> <Esc>:call Make()<CR>a
		else
			map <F5> :wa<CR>:make %:r<CR>:cw<CR><CR>
			imap <F5> <Esc>:wa<CR>:make %:r<CR>:cw<CR>a
		endif
	endfunction
	au FileType c,cc,cpp,cxx,h,hpp,hxx,pas,inl,s,tex call BindF5_C()
	au FileType python map <F5> :!clear;python %<CR>
	" выход аля mc
	nmap <F10> :qa<CR>
	" F12 - обозреватель файлов
	map <F12> :NERDTree<cr>
	vmap <F12> <esc>:NERDTree<cr>a
	imap <F12> <esc>:NERDTree<cr>a

	" обновить ctags
	map <C-u> :!ctags -R --languages=c,c++,python --c++-kinds=+pl --python-kinds=-iv --fields=+ilaS --extra=+q --sort=yes .<CR>

	" проверка орфографии
	map <C-p> :setlocal spell spelllang=en,ru<cr>

	" Ctrl+T - новый буфер, Shift+Tab - перейти к следующему буферу, Ctrl+Tab - перейти к предыдущему буферу:
	map <S-tab> :bp<cr>
	nmap <S-tab> :bp<cr>
	imap <S-tab> <ESC>:bp<cr>a
	map <C-tab> :bn<cr>
	nmap <C-tab> :bn<cr>
	imap <C-tab> <ESC>:bn<cr>a
	nmap <C-t> :new<cr>
	imap <C-t> <ESC>:new<cr>a
	nmap <C-w> :BW<cr>
	imap <C-w> <ESC>:BW<cr>a

	" Переход между сплитами по Ctrl-стрелки
	nmap <silent> <C-Up> :wincmd k<CR>
	nmap <silent> <C-Down> :wincmd j<CR>
	nmap <silent> <C-Left> :wincmd h<CR>
	nmap <silent> <C-Right> :wincmd l<CR>

	" C++ goto definition = leader-d
	function! GotoDefBind()
		nnoremap <leader>d <C-]>
	endfunction
	au FileType c,cc,cpp,cxx,h,hpp,hxx call GotoDefBind()

	if filereadable("/usr/share/clang/clang-format.py")
		map <C-K> :pyf /usr/share/clang/clang-format.py<cr>
		imap <C-K> <c-o>:pyf /usr/share/clang/clang-format.py<cr>
	endif

	" не терять выделение при сдвигах
	xnoremap <  <gv
	xnoremap >  >gv

	" починка кодировки
	menu Encoding.CP1251   :e ++enc=cp1251<CR>
	menu Encoding.CP866    :e ++enc=cp866<CR>
	menu Encoding.KOI8-U   :e ++enc=koi8-u<CR>
	menu Encoding.UTF-8    :e ++enc=utf-8<CR>
	nnoremap <leader>e :emenu Encoding.<TAB>
" }

