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
% UnaryExpr    = BasicExpr | unary_op UnaryExpr .
% BasicExpr    = identifier


% Third step - BinaryExpr
%
% BoolExpr     = Expression .
% Expression   = UnaryExpr | Expression binary_op Expression .
% UnaryExpr    = BasicExpr | unary_op UnaryExpr .
% BasicExpr    = identifier

Nonterminals BasicExpr BoolExpr Expression UnaryExpr logical_op unary_op.

Terminals bang identifier not or.

Rootsymbol BoolExpr.
Left 100 or.

BoolExpr -> Expression : {bool_expr, '$1'}.

Expression -> UnaryExpr : {expression, '$1'}.
Expression -> Expression logical_op Expression : {expression, '$1', '$3', '$2'}.

UnaryExpr -> unary_op UnaryExpr : {unary_expr, '$2', '$1'}.
UnaryExpr -> BasicExpr : '$1'.

BasicExpr -> identifier : extract('$1').

unary_op -> not : extract('$1').
unary_op -> bang : extract('$1').

logical_op -> or : extract('$1').

Erlang code.

extract({Type, _Line, Value}) -> {Type, Value}.
