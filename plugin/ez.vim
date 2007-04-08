

" Default config
if !exists('EzSideBarWidth')
    let EzSideBarWidth = 42
endif
if !exists('EzBrowser')
    let EzBrowser='firefox'
endif

let EzSideBarName="ezbar"
let EzAttributeDocBase="http://ez.no/doc/content/advancedsearch?&SearchText="

" Abbreviations for template
autocmd BufNewFile,BufRead *.tpl call EzTplEnvironment()

command! -nargs=1 -bar Ezcv call Ezcv('<args>')
abbreviate cv Ezcv

pyf ~/.vim/plugin/ez.py
function! Ezcv(siteurl)
    let winnum = bufwinnr(g:EzSideBarName)
    let python_func = 'py eZClassesView("'.a:siteurl.'")'
    if winnum != -1
        " windows already exists, just refresh
        exec winnum . 'wincmd w'
        exec python_func
        return
    endif
    let bufnum = bufnr(g:EzSideBarName)
    if bufnum == -1
        " no buffer for classes view, creating one
        badd g:EzSideBarName
    endif
    exe 'silent! topleft vertical '.g:EzSideBarWidth.' split +0 '.g:EzSideBarName
    set buftype=nofile
    set bufhidden=hide
    set noswapfile
    setlocal nowrap
    setlocal nonumber
    setlocal filetype=g:EzSideBarName
    setlocal foldmethod=manual
    setlocal foldtext=v:folddashes.substitute(getline(v:foldstart),'\ \ ','','g')
    if has('gui_running')
        " dont need foldcolumn in a terminal
        setlocal foldcolumn=3
    endif

    " Highligthing data
    syntax match ezClassGroup '^[^ ][A-Z0-9a-z]* '
    syntax match ezClassViewTitle /^Site:.*/
	syntax match ezError /^Error:.*$/
    syntax region ezClassIdentifier start="o .* \[" end="\["
    syntax region ezStringIdentifier start="\["hs=e+1 end="\]"he=s-1
    syntax region ezClassName start="  o "hs=e+1 end=" #"he=s-1
    syntax region ezRequired start="+ "hs=e+1 end=" "he=s-1
    highlight default link ezClassGroup Title
    highlight default link ezClassName PreProc
    highlight default link ezClassIdentifier PreProc
    highlight default link ezStringIdentifier Type
    highlight default link ezRequired Special
	highlight default link ezError Error

    " Simplier keybindings
    nnoremap <buffer> <silent> + :silent! foldopen<CR>
    nnoremap <buffer> <silent> - :silent! foldclose<CR>
    nnoremap <buffer> <silent> * :silent! %foldopen!<CR>
    nnoremap <buffer> <silent> = :silent! %foldclose<CR>
    nnoremap <buffer> <silent> d :call OpenEzDoc()<CR>
    
    exec python_func
endfunction


function! OpenEzDoc()
    if !exists('*system') || !executable(g:EzBrowser)
        return 
    endif
    let type=substitute(getline('.'), '.*\[\(.*\)\].*', '\1', '')
    let url=g:EzAttributeDocBase . type
    let cmd= g:EzBrowser.' "'.url.'"'
    let res = system(cmd)
    return 
endfunction


function! EzTplEnvironment()
	"""""""""" Control structures
	iabbrev ezfe {foreach __ as $k => $val}<CR><CR>{/foreach}
	iabbrev ezfes {foreach __ as $k => $val sequence array( __ ) as $seq}<CR><CR>{/foreach}

	"""""""""" Fetch
	iabbrev ezfcn fetch(content, node, hash('node_id' , __ ))<ESC>4h

	" content list
	iabbrev ezfcl fetch(content, list, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))
	iabbrev ezfcls fetch(content, list, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'sort_by', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))
	iabbrev ezfcla fetch(content, list, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'attribute_filter', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))
	iabbrev ezfclas fetch(content, list, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'sort_by', array( __ ),<CR>'attribute_filter', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))
	iabbrev ezfclsa fetch(content, list, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'sort_by', array( __ ),<CR>'attribute_filter', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))

	" content list_count
	iabbrev ezfclc fetch(content, list_count, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))
	iabbrev ezfclca fetch(content, list_count, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'attribute_filter', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))

	" content tree
	iabbrev ezfct fetch(content, tree, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))
	iabbrev ezfcts fetch(content, tree, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'sort_by', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))
	iabbrev ezfcta fetch(content, tree, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'attribute_filter', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))
	iabbrev ezfctas fetch(content, tree, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'sort_by', array( __ ),<CR>'attribute_filter', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))
	iabbrev ezfctsa fetch(content, tree, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'sort_by', array( __ ),<CR>'attribute_filter', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))

	" content tree_count
	iabbrev ezfctc fetch(content, tree_count, hash('parent_node_id', __ ,<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))
	iabbrev ezfctca fetch(content, tree_count, hash('parent_node_id', __ ,<CR>'attribute_filter', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))

endfunction





" TODO
"command! -nargs=0 -bar Eztc call EzTemplateCheck()
"function! EzTemplateCheck()
"    let bufnum = bufnr(g:EzSideBarName)
"    if bufnum == -1
"        " no sidebar buffer, can't guess the URL
"		echoerr 'No sidebar buffer, use load Classes View first'
"		return
"    endif
"	let python_func = 'py eZTemplateCheck('.bufnum.')'
"	exec python_func
"endfunction


