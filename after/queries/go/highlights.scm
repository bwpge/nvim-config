; extends

;; for whatever reason golsp does not provide semantic tokens for escapes so
;; use this query to override the semantic token priority
((escape_sequence) @string.escape
 (#set! "priority" 199))
