% BoolExpr     = Expression .
% Expression   = UnaryExpr .
% UnaryExpr    = BasicExpr | unary_op UnaryExpr .
% BasicExpr    = Operand .
% Operand      = Literal | NamedOperand .
% Literal      = BasicLit .
% BasicLit     = int_lit .
% NamedOperand = identifier .
% 


% First step - only booleans
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

Nonterminals bool_expr expression.

Terminals identifier.

Rootsymbol bool_expr.

bool_expr -> expression : {bool_expr, '$1'}.

expression -> identifier : {expression, extract('$1')}.

Erlang code.

% extract_value({_,V}) -> V.
extract({Type, _Line, Value}) -> {Type, Value}.
