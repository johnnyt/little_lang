Definitions.

WHITESPACE = [\s\t\n\r]
COMMENT    = #.*
BANG       = !
NOT        = not
IDENTIFIER = [_a-zA-Z][_a-zA-Z0-9]*

Rules.

{INT}         : {token, {int_lit, TokenLine, list_to_integer(TokenChars)}}.
{BANG}        : {token, {bang, TokenLine, list_to_atom(TokenChars)}}.
{NOT}         : {token, {not_, TokenLine, list_to_atom(TokenChars)}}.
{IDENTIFIER}  : {token, {identifier, TokenLine, list_to_binary(TokenChars)}}.
{COMMENT}     : skip_token.
{WHITESPACE}+ : skip_token.

Erlang code.
