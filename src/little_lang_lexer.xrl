Definitions.

WHITESPACE  = [\s\t\n\r]
COMMENT     = #.*
IDENTIFIER  = [_a-zA-Z][_a-zA-Z0-9]*
BOOL        = (true|false)

Rules.

{BOOL}        : {token, {bool_lit, TokenLine, list_to_atom(TokenChars)}}.
!             : {token, {bang, TokenLine, list_to_binary(TokenChars)}}.
not           : {token, {'not', TokenLine, list_to_binary(TokenChars)}}.
or            : {token, {'or', TokenLine, list_to_binary(TokenChars)}}.
,             : {token, {comma, TokenLine, list_to_binary(TokenChars)}}.
\(            : {token, {open_paren, TokenLine, list_to_binary(TokenChars)}}.
\)            : {token, {close_paren, TokenLine, list_to_binary(TokenChars)}}.
{IDENTIFIER}  : {token, {identifier, TokenLine, list_to_binary(TokenChars)}}.
{COMMENT}     : skip_token.
{WHITESPACE}+ : skip_token.

Erlang code.
