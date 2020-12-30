Definitions.

WHITESPACE  = [\s\t\n\r]
COMMENT     = #.*
BANG        = !
NOT         = not
OR          = or
COMMA       = ,
OPEN_PAREN  = \(
CLOSE_PAREN = \)
IDENTIFIER  = [_a-zA-Z][_a-zA-Z0-9]*

Rules.

{INT}         : {token, {int_lit, TokenLine, list_to_integer(TokenChars)}}.
{BANG}        : {token, {bang, TokenLine, list_to_binary(TokenChars)}}.
{NOT}         : {token, {'not', TokenLine, list_to_binary(TokenChars)}}.
{OR}          : {token, {'or', TokenLine, list_to_binary(TokenChars)}}.
{COMMA}       : {token, {comma, TokenLine, list_to_binary(TokenChars)}}.
{OPEN_PAREN}  : {token, {open_paren, TokenLine, list_to_binary(TokenChars)}}.
{CLOSE_PAREN} : {token, {close_paren, TokenLine, list_to_binary(TokenChars)}}.
{IDENTIFIER}  : {token, {identifier, TokenLine, list_to_binary(TokenChars)}}.
{COMMENT}     : skip_token.
{WHITESPACE}+ : skip_token.

Erlang code.
