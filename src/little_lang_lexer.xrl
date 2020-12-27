Definitions.

INT        = [0-9]+
WHITESPACE = [\s\t\n\r]

Rules.

{INT}         : {token, {int_lit, TokenLine, list_to_integer(TokenChars)}}.
{WHITESPACE}+ : skip_token.

Erlang code.
