if version < 600
        syntax clear
elseif exists("b:current_syntax")
        finish
endif

syntax keyword CVSkeyword head branch locks
syntax keyword CVSkeyword date author state commitid

syntax match cvsRevision /^revision [0-9.]\+/
syntax match cvsSeparator /^[-]\{5,}/

if !exists("b:did_cvslog_syntax_inits")
        let b:did_cvslog_syntax_inits = 1
        highlight link cvsRevision      Statement
        highlight link cvsKeyword       Keyword
        highlight link cvsSeparator     Special
endif

let b:current_syntax="CVSLog"
