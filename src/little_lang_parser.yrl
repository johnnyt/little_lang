% BoolExpr     = Expression .
% Expression   = UnaryExpr .
% UnaryExpr    = BasicExpr | unary_op UnaryExpr .
% BasicExpr    = Operand .
% Operand      = Literal | NamedOperand .
% Literal      = BasicLit .
% BasicLit     = int_lit .
% NamedOperand = identifier .
% 


% First step - only identifiers
%
% BoolExpr     = Expression .
% Expression   = UnaryExpr .
% UnaryExpr    = BasicExpr .
% BasicExpr    = Operand .
% Operand      = NamedOperand .
% NamedOperand = identifier .
%
% =>
%
% BoolExpr     = Expression .
% Expression   = identifier .


% Second step - unary_op
%
% BoolExpr     = Expression .
% Expression   = UnaryExpr .
% UnaryExpr    = BasicExpr | unary_op UnaryExpr.
% BasicExpr    = Operand .
% Operand      = NamedOperand .
% NamedOperand = identifier .
%
% =>
%
% BoolExpr     = Expression .
% Expression   = identifier | unary_op Expression.


Nonterminals basic_expr bool_expr expression unary_expr.

Terminals bang identifier.

Rootsymbol bool_expr.

bool_expr -> expression : {bool_expr, '$1'}.

expression -> unary_expr : {expression, '$1'}.

unary_expr -> bang unary_expr : {not_, '$2', extract('$1')}.
unary_expr -> basic_expr : {unary_expr, '$1'}.

basic_expr -> identifier : {basic_expr, extract('$1')}.

Erlang code.

% extract_value({_,V}) -> V.
extract({Type, _Line, Value}) -> {Type, Value}.
