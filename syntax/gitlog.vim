if v:version < 600
        syntax clear
elseif exists('b:current_syntax')
        finish
endif

syntax keyword gitkeyword Author commit Date

syntax match gitsGUID /[0-9a-z]\{20,}/

if !exists('b:did_gitlog_syntax_inits')
        let b:did_gitlog_syntax_inits = 1
        highlight link gitsGUID     Statement
        highlight link gitKeyword   Keyword
endif

let b:current_syntax='gitLog'

