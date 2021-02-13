" set location of master bib file
let g:pandoc#biblio#bibs = ["~/Documents/masterLib.bib"]
let g:pandoc#completion#bib#mode = 'citeproc'

" disable folding of headers
let g:pandoc#modules#disabled = ["folding"]
