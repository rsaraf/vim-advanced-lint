vim-advanced-lint
================
A customizable c++ linting vim plugin that supports cpplint
CPPLint is a tool by Google to check for style errors etc


Installation
------------
1. Use vim-plug plugin manager and add

         Plug 'rsaraf/vim-advanced-lint'

2. or use Vundle

         Plugin 'rsaraf/vim-advanced-lint'

3. or use Pathogen
   and copy the contents of this repo to ~/.vim/bundle

Usage
-----
1. Open a C++ file
2. Press `<F7>` to run `cpplint` on it

It shows the errors inside a quickfix window, which will allow your to quickly
jump to the error locations by simply pressing [Enter].

Customization
-------------
OPTIONS AVAILABLE:

1. 'g:cpplint_cmd'

         Points to the cpplint executable

         Default => g:cpplint_cmd = 'cpplint.py'

2. 'g:cpplint_extensions'

         Specify the file extentions on which cpplint should be used
   
         Default => g:cpplint_extensions = "cc,h,cpp,hpp"

3. 'g:cpplint_line_length'
     
         Specify the line length check param. Passed to cpplint only when configured

4. 'g:cpplint_filter'

         Specify filters. Example g:cpplint_filter = '-runtime/references'

5. Anything else? Feel free to add!

If you don't want to use the `<F7>` key for cpplint-checking, simply remap it
to another key. It autodetects whether it has been remapped and won't register
the `<F7>` key if so. For example, to remap it to `<F3>` instead, use:

    autocmd FileType cpp map <buffer> <F3> :call Cpplint()<CR>

Tips
----
To run Cpplint everytime you save a buffer, simply add this to vimrc

    autocmd BufWritePost *.h,*.cpp call Cpplint()

In case you have different projects, and want to configure them differently,
you can use this

    function! SetupEnvironment()
      let l:path = expand('%:p')
      if l:path =~ '/home/user/projects/Project1'
        let g:cpplint_filter = '-runtime/references'
      elseif l:path =~ '/home/user/projects'
        let g:cpplint_filter = '-legal/copyright'
      endif
    endfunction
    autocmd! BufReadPost,BufNewFile * call SetupEnvironment()
