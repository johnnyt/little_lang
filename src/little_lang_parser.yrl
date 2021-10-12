Nonterminals
  Arguments BasicExpr BinaryOp BoolExpr DualOp Expression ExpressionList
  ListExpr LogicalOp Operand RelOp UnaryExpr UnaryOp.

Terminals
  bang bool_lit colon_colon comma equals identifier int_lit minus not or plus
  string_lit type
  open_bracket close_bracket open_paren close_paren.

Rootsymbol BoolExpr.

Left 10 LogicalOp.
Left 20 RelOp.
Left 30 BinaryOp.
Left 40 colon_colon.

BoolExpr   -> Expression          : {bool_expr, '$1'}.

Expression -> UnaryExpr                         : '$1'.
Expression -> Expression BinaryOp Expression    : {binary_expr, '$2', '$1', '$3'}.
Expression -> Expression RelOp Expression       : {binary_expr, '$2', '$1', '$3'}.
Expression -> Expression colon_colon type       : {conversion, extract('$3'), '$1'}.

UnaryExpr  -> UnaryOp UnaryExpr   : {unary_expr, '$1', '$2'}.
UnaryExpr  -> BasicExpr           : '$1'.

BasicExpr  -> Operand             : '$1'.
BasicExpr  -> ListExpr            : {list_expr, '$1'}.
BasicExpr  -> BasicExpr Arguments : {call_expr, '$1', '$2'}.
BasicExpr  -> open_paren Expression close_paren : {group_expr, '$2'}.

Operand    -> bool_lit            : extract('$1').
Operand    -> int_lit             : extract('$1').
Operand    -> string_lit          : extract('$1').
Operand    -> identifier          : extract('$1').

ListExpr   -> open_bracket close_bracket : [].
ListExpr   -> open_bracket ExpressionList close_bracket : '$2'.

Arguments  -> open_paren close_paren : [].
Arguments  -> open_paren ExpressionList close_paren : '$2'.

ExpressionList -> Expression : ['$1'].
ExpressionList -> Expression comma ExpressionList : ['$1' | '$3'].

UnaryOp    -> bang    : extract('$1').
UnaryOp    -> minus   : extract('$1').
UnaryOp    -> not     : extract('$1').

BinaryOp   -> or      : extract('$1').
BinaryOp   -> plus    : extract('$1').
BinaryOp   -> minus   : extract('$1').

RelOp      -> equals  : extract('$1').

Erlang code.

extract({Type, _Line, Value}) -> {Type, Value}.
