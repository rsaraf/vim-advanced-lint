"
" C++ filetype plugin for running cpplint.py
" Language:     C++ (ft=cpp)
" Maintainer:   Rohit Saraf <rohit.kumar.saraf@gmail.com>
" Version:      Vim 7
"
" Code is borrowed from vim-flake8 and funorpain and and flexibility/more options have been
" added.
"
" Only do this when not done yet for this buffer
if exists("b:loaded_cpplint_ftplugin")
    finish
endif
let b:loaded_cpplint_ftplugin=1

"let s:cpplint_cmd = g:cpplint_cmd

if !exists("*Cpplint()")
    function Cpplint()
        if !exists('g:cpplint_cmd')
          let g:cpplint_cmd = "cpplint.py"
        endif

        let g:cpplint_cmd_opts = ''
        if exists("g:cpplint_extensions")
          let g:cpplint_cmd_opts = ' --extensions=' . g:cpplint_extensions . ' '
        endif
        " line length
        if exists('g:cpplint_line_length')
          let g:cpplint_cmd_opts = g:cpplint_cmd_opts . ' --linelength=' . g:cpplint_line_length . ' '
        endif

        " filters
        if exists('g:cpplint_filter')
          let g:cpplint_cmd_opts = g:cpplint_cmd_opts . ' --filter=' . g:cpplint_filter . ' '
        endif

        if !executable(g:cpplint_cmd)
            echoerr "File " . g:cpplint_cmd . " not found. Please install it first."
            return
        endif

        set lazyredraw   " delay redrawing
        cclose           " close any existing cwindows

        " store old grep settings (to restore later)
        let l:old_gfm=&grepformat
        let l:old_gp=&grepprg

        " write any changes before continuing
        if &readonly == 0
            update
        endif

        " perform the grep itself
        let &grepformat = "%f:%l: %m"
        let &grepprg    = g:cpplint_cmd . g:cpplint_cmd_opts . ' '
        silent! grep! %

        " Ensure we don't give a popup saying 0 errors :P
        let has_results = 0
        let errorList = []
        for va in getqflist()
            if va.text =~ "Total errors found: 0"
                let has_results = 0
                break
            endif

            if va.text =~ "Done processing"
                continue
            endif

            if va.text =~ "Total errors"
                continue
            endif

            let has_results = 1
            call add(errorList, va)
        endfor

        call setqflist(errorList)

        " restore grep settings
        let &grepformat=l:old_gfm
        let &grepprg=l:old_gp

        " open cwindow
        if has_results
            execute 'belowright copen'
            setlocal wrap
            nnoremap <buffer> <silent> c :cclose<CR>
            nnoremap <buffer> <silent> q :cclose<CR>
        endif

        set nolazyredraw
        redraw!

        if has_results == 0
            " Show OK status
            hi Green ctermfg=green
            echohl Green
            echon "CPPLINT CHECK OK!"
            echohl
        endif
    endfunction
endif

" Add mappings, unless the user didn't want this.
" The default mapping is registered under to <F7> by default, unless the user
" remapped it already (or a mapping exists already for <F7>)
if !exists("no_plugin_maps") && !exists("no_cpplint_maps")
    if !hasmapto('Cpplint(')
        noremap <buffer> <F7> :call Cpplint()<CR>
        noremap! <buffer> <F7> :call Cpplint()<CR>
    endif
endif
