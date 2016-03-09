if version < 600
        syntax clear
elseif exists("b:current_syntax")
        finish
endif

syntax match SVNkeyword /Changed paths/
syntax match SVNkeyword /^\s\{3,}\zs[MAD]\>/
syntax keyword SVNkeyword date author state commitid

syntax match svnRevision /^revision [0-9.]\+/
syntax match svnSeparator /^[-]\{5,}/

if !exists("b:did_svnlog_syntax_inits")
        let b:did_svnlog_syntax_inits = 1
        highlight link svnRevision      Statement
        highlight link svnKeyword       Keyword
        highlight link svnSeparator     Special
endif

let b:current_syntax="SVNLog"

