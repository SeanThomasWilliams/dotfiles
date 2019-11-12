au! BufRead,BufNewFile *.md set filetype=markdown makeprg=pandoc\ --from\ gfm\ --to\ html5\ --highlight-style=haddock\ --self-contained\ --metadata\ title=%:r\ %\ >%<.html
