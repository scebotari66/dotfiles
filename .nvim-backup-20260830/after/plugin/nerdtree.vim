call NERDTreeAddMenuItem({'text': '(f)ind in directory', 'shortcut': 'f', 'callback': 'NERDTreeFerretPath'})

function! NERDTreeFerretPath()
    let curDirNode = g:NERDTreeDirNode.GetSelected()
    let path = curDirNode.path.str()

    call inputsave()
    let search_arg = input('Text to search: ')
    call inputrestore()

    if search_arg != ''
        execute 'Ack '.fnameescape(search_arg).' '.fnameescape(path)
    endif
endfunction
