au BufRead,BufNewFile *.Rmd		set filetype=rmarkdown

" add support from pandoc_syntax 
au! BufNewFile,BufFilePre,BufRead *.Rmd set filetype=markdown.pandoc
