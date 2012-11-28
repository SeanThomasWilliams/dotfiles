syn include @pythonSyn syntax/python.vim
syn match logDate /^\d\{4}-\d\{2}-\d\{2}/ nextgroup=logTime skipwhite
syn match logTime /\d\{2}:\d\{2}:\d\{2},\d\{3}/ nextgroup=logError,logWarn,foo1
syn match enter /<<:Calling / nextgroup=fname
syn match fname /[^\(]\+/ contained
syn match logError /ERROR/ nextgroup=foo1
syn match logWarn /WARN(ING)\?/ nextgroup=foo1
syn match logDebug /DEBUG/ nextgroup=foo1
syn match logInfo /INFO/ nextgroup=foo1

syn match foo1 /[^[]\+\[/ contained nextgroup=module
syn match module /[^]]\+/ contained
syn match openFold /<<;/
syn match closeFold /;>>/

syn region result	start=+^result =+	end=+;>>+ contains=@pythonSyn

hi Discrete gui=NONE guifg=#333333 guibg=NONE

hi link logDate Comment
hi link logTime String
hi link enter Comment
hi link fname Function
hi link module Function
hi link openFold Discrete
hi link closeFold Discrete
hi link logError Error
