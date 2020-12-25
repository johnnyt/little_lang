defmodule LittleLang.Lexer do
  @moduledoc """
  Module to lex a string of characters into a list of tokens.
  """

  @spec lex(string :: binary()) :: list()
  @doc """
  Lex a string of characters into a list of tokens.
  """
  def lex(string) do
    {:ok, tokens, _} =
      string
      |> String.to_charlist()
      |> :little_lang_lexer.string()

    {:ok, tokens}
  end
end
