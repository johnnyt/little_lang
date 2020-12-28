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


Nonterminals BasicExpr BoolExpr Expression UnaryExpr.

Terminals bang identifier.

Rootsymbol BoolExpr.

BoolExpr -> Expression : {bool_expr, '$1'}.

Expression -> UnaryExpr : {expression, '$1'}.

UnaryExpr -> bang UnaryExpr : {not_, '$2', extract('$1')}.
UnaryExpr -> BasicExpr : {unary_expr, '$1'}.

BasicExpr -> identifier : {basic_expr, extract('$1')}.

Erlang code.

% extract_value({_,V}) -> V.
extract({Type, _Line, Value}) -> {Type, Value}.
