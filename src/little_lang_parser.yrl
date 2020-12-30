Nonterminals
  Arguments BasicExpr BoolExpr Expression ExpressionList LogicalOp
  Operand UnaryExpr UnaryOp.

Terminals
  bang bool_lit comma identifier not or open_paren close_paren.

Rootsymbol BoolExpr.

Left 100 or.

BoolExpr   -> Expression          : {bool_expr, '$1'}.

Expression -> UnaryExpr           : '$1'.
Expression -> Expression LogicalOp Expression : {binary_expr, '$2', '$1', '$3'}.

UnaryExpr  -> UnaryOp UnaryExpr   : {unary_expr, '$1', '$2'}.
UnaryExpr  -> BasicExpr           : '$1'.

BasicExpr  -> Operand             : extract('$1').
BasicExpr  -> BasicExpr Arguments : {call_expr, extract('$1'), '$2'}.

Operand    -> bool_lit            : extract('$1').
Operand    -> identifier          : extract('$1').

Arguments      -> open_paren close_paren : [].
Arguments      -> open_paren ExpressionList close_paren : '$2'.
ExpressionList -> Expression      : ['$1'].
ExpressionList -> Expression comma ExpressionList : ['$1' | '$3'].

UnaryOp    -> not  : extract('$1').
UnaryOp    -> bang : extract('$1').
LogicalOp  -> or   : extract('$1').

Erlang code.

extract({Type, _Line, Value}) -> {Type, Value};
extract({Type, Value}) -> {Type, Value}.
