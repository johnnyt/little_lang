Definitions.

WHITESPACE  = [\s\t\n\r]
COMMENT     = #.*
IDENTIFIER  = [_a-zA-Z][_a-zA-Z0-9]*
BOOL        = (true|false)
INT         = [0-9]+
STRING      = ("(\?:\\.|[^\\""])*"|'((\?:\\.|[^\\''])*)')

Rules.

{BOOL}        : {token, {bool_lit, TokenLine, list_to_atom(TokenChars)}}.
{INT}         : {token, {int_lit, TokenLine, list_to_integer(TokenChars)}}.
{STRING}      : {token, {string_lit, TokenLine, extract_string(TokenChars, TokenLen)}}.
!             : {token, {bang, TokenLine, list_to_binary(TokenChars)}}.
not           : {token, {'not', TokenLine, list_to_binary(TokenChars)}}.
or            : {token, {'or', TokenLine, list_to_binary(TokenChars)}}.
-             : {token, {minus, TokenLine, list_to_binary(TokenChars)}}.
,             : {token, {comma, TokenLine, list_to_binary(TokenChars)}}.
\+            : {token, {plus, TokenLine, list_to_binary(TokenChars)}}.
=             : {token, {equals, TokenLine, list_to_binary(TokenChars)}}.
\(            : {token, {open_paren, TokenLine, list_to_binary(TokenChars)}}.
\)            : {token, {close_paren, TokenLine, list_to_binary(TokenChars)}}.
\[            : {token, {open_bracket, TokenLine, list_to_binary(TokenChars)}}.
\]            : {token, {close_bracket, TokenLine, list_to_binary(TokenChars)}}.
{IDENTIFIER}  : {token, {identifier, TokenLine, list_to_binary(TokenChars)}}.
{COMMENT}     : skip_token.
{WHITESPACE}+ : skip_token.

Erlang code.

extract_string(TokenChars, TokenLen) ->
  list_to_binary(string:slice(TokenChars, 1, TokenLen-2)).
