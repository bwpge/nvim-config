; extends
(generic_type
  type_arguments: (type_arguments
    "<"
    .
    (_) @start @end
    (_)? @end
    .
    ">"
    (#make-range! "generic.inner" @start @end)))

(generic_type) @generic.outer
