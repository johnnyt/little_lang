Definitions.

INT        = [0-9]+

Rules.

{INT}         : {token, {int_lit, TokenLine, list_to_integer(TokenChars)}}.

Erlang code.
