Definitions.

INT        = [0-9]+
WHITESPACE = [\s\t\n\r]
COMMENT    = #.*
REL_OP     = (is|is\s+not|=|!=|<|<=|>|>=|)
UNARY_OP   = (\+|-|!|not)

Rules.

true          : {token, {bool_lit, TokenLine, true}}.
false         : {token, {bool_lit, TokenLine, false}}.
{INT}         : {token, {int_lit, TokenLine, list_to_integer(TokenChars)}}.
{UNARY_OP}    : {token, {op, TokenLine, list_to_atom(TokenChars)}}.
{REL_OP}      : {token, {op, TokenLine, list_to_atom(TokenChars)}}.
{COMMENT}     : skip_token.
{WHITESPACE}+ : skip_token.

Erlang code.
