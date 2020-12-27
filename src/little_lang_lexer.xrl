Definitions.

INT        = [0-9]+
WHITESPACE = [\s\t\n\r]
COMMENT    = #.*

Rules.

{INT}         : {token, {int_lit, TokenLine, list_to_integer(TokenChars)}}.
{COMMENT}     : skip_token.
{WHITESPACE}+ : skip_token.

Erlang code.
