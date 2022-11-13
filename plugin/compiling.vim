function! s:JobCallback(channel, msg)
    call setqflist([], 'a', {'lines': [a:msg]}) 
endfunction

function! s:MyCloseHandler(channel)
    let g:isjobrunning = 1
    if job_info(ch_getjob(a:channel)).exitval == 0
        echom "success"
    else
        copen
    endif
endfunction

function! s:TermRun(args, mode)
    wall " Save all (writable) buffers
    if a:mode == "new"
        let g:cmd=expand(&l:makeprg .. " " .. expand(a:args))
        let &g:efm = &l:efm
        echom g:cmd
        call term_start(g:cmd)
    elseif a:mode == "term"
        if !exists("g:cmd")
            echom "Set g:cmd with QS"
        else
            call term_start(g:cmd)
        endif
    elseif a:mode == "quick"
        if !exists("g:cmd")
            echom "Set g:cmd with QS"
        else
            if (exists("g:isjobrunning") && (g:isjobrunning == 0))
                echom "Job already running. Kill it with QD"
            else
                let g:isjobrunning = 0
                cclose
                call setqflist([], "r") 
                let g:job = job_start(g:cmd, {"close_cb": "<SID>MyCloseHandler", "callback": "<SID>JobCallback"})
            endif
        endif
    endif
endfunction


command -nargs=* -complete=file -bar DeBug :call <SID>TermRun('<args>', 'new')

nnoremap QS :DeBug <C-R>r
nnoremap QT :call <SID>TermRun("", "term")<cr>
nnoremap QQ :call <SID>TermRun("", "quick")<cr>
nnoremap QD :call job_stop(g:job)<cr>
