vim-advanced-lint
================
A customizable c++ linting vim plugin that supports cpplint
CPPLint is a tool by Google to check for style errors etc


Installation
------------
1. Use vim-plug plugin manager and add

         Plug 'rsaraf/vim-advanced-lint'
  
   vim-plug is awesome. To have it configure it on its own, just add this to your .vimrc
   
         " automatically install plug.vim if not installed
         if empty(glob('~/.vim/autoload/plug.vim'))
           silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
              \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
           autocmd VimEnter * PlugInstall
         endif
         
         " set the runtime path to include Vundle and initialize
         call plug#begin('~/.vim/bundle')

         " Add all your other plugins here.
         Plug 'rsaraf/vim-advanced-lint'
         
         call plug#end()
         
   For more details on vim-plug
   
         https://github.com/junegunn/vim-plug

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
      if l:path =~ '/PROJECT1/'
        let g:cpplint_filter = '-runtime/references'
        autocmd BufWritePost *.h,*.cpp call Cpplint()
      elseif l:path =~ '/PROJECT2/'
        let g:cpplint_filter = '-legal/copyright'
        autocmd BufWritePost *.h,*.cpp call Cpplint()
      " For other projects, don't call Cpplint automatically
      endif
    endfunction
    autocmd! BufReadPost,BufNewFile * call SetupEnvironment()
