Nonterminals
  Arguments BasicExpr BinaryOp BoolExpr DualOp Expression ExpressionList LogicalOp
  Operand RelOp UnaryExpr UnaryOp.

Terminals
  bang bool_lit comma equals identifier int_lit minus not or plus string_lit
  open_paren close_paren.

Rootsymbol BoolExpr.

Left 10 LogicalOp.
Left 20 RelOp.
Left 30 DualOp.

BoolExpr   -> Expression          : {bool_expr, '$1'}.

Expression -> UnaryExpr                         : '$1'.
Expression -> Expression BinaryOp Expression    : {binary_expr, '$2', '$1', '$3'}.
BasicExpr  -> open_paren Expression close_paren : {group_expr, '$2'}.

UnaryExpr  -> UnaryOp UnaryExpr   : {unary_expr, '$1', '$2'}.
UnaryExpr  -> BasicExpr           : '$1'.

BasicExpr  -> Operand             : '$1'.
BasicExpr  -> BasicExpr Arguments : {call_expr, '$1', '$2'}.

Operand    -> bool_lit            : extract('$1').
Operand    -> int_lit             : extract('$1').
Operand    -> string_lit          : extract('$1').
Operand    -> identifier          : extract('$1').

Arguments      -> open_paren close_paren : [].
Arguments      -> open_paren ExpressionList close_paren : '$2'.
ExpressionList -> Expression : ['$1'].
ExpressionList -> Expression comma ExpressionList : ['$1' | '$3'].

UnaryOp    -> bang    : extract('$1').
UnaryOp    -> minus   : extract('$1').
UnaryOp    -> not     : extract('$1').

BinaryOp   -> RelOp     : '$1'.
BinaryOp   -> LogicalOp : '$1'.
BinaryOp   -> DualOp    : '$1'.

LogicalOp  -> or      : extract('$1').

RelOp      -> equals  : extract('$1').

DualOp     -> plus    : extract('$1').
DualOp     -> minus   : extract('$1').

Erlang code.

extract({Type, _Line, Value}) -> {Type, Value}.
