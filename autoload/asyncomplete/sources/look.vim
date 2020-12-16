
function! asyncomplete#sources#look#get_source_options(opt)
    return a:opt
endfunction

function! s:typed_kw(typed) abort
  return matchstr(a:typed, '\v[a-zA-Z]{2,}$')
endfunction

" asyncomplete
function! asyncomplete#sources#look#completor(opt, ctx) abort
  let l:col = a:ctx['col']
  let l:typed = a:ctx['typed']

  let l:kw = s:typed_kw(l:typed)
  let l:kwlen = len(l:kw)

  let l:startcol = l:col - l:kwlen

  if l:kwlen < 2
    call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol, [], 1)
    return
  endif

  let l:look = system('look '. l:kw)

  " if l:kw starts with an uppercase, result should start with uppercase
  if match(l:kw[0], '\u') >= 0
    let l:matches = map(split(l:look, "\n"), {key, val -> {'menu': '[look]', 'word': toupper(val[0]) . val[1:]}})
  else
    let l:matches = map(split(l:look, "\n"), {key, val -> {'menu': '[look]', 'word': val}})
  endif

  call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol, l:matches)
endfunction

function! asyncomplete#sources#look#good_words(opt, ctx) abort
  let l:col = a:ctx['col']
  let l:typed = a:ctx['typed']

  let l:kw = s:typed_kw(l:typed)
  let l:kwlen = len(l:kw)

  let l:startcol = l:col - l:kwlen

  if l:kwlen < 2
    call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol, [], 1)
    return
  endif

  let g:asc_look_good_words_file = get(g:, 'asc_look_good_words_file', '~/.vim/spell/en.utf-8.add')
  let l:grep = system('grep -i ^' . l:kw . ' ' . g:asc_look_good_words_file)

  " if l:kw starts with an uppercase, result should start with uppercase
  if match(l:kw[0], '\u') >= 0
    let l:matches = map(split(l:grep, "\n"), {key, val -> {'menu': '[lookgw]', 'word': toupper(val[0]) . val[1:]}})
  else
    let l:matches = map(split(l:grep, "\n"), {key, val -> {'menu': '[lookgw]', 'word': val}})
  endif

  call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol, l:matches)
endfunction
