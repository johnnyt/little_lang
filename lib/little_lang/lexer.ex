defmodule LittleLang.Lexer do
  @moduledoc """
  Module to lex a string of characters into a list of tokens.
  """

  @spec tokenize(string :: binary()) :: {:ok, list()}
  @doc """
  Lex a string of characters into a list of tokens.
  """
  def tokenize(string) do
    {:ok, tokens, _} =
      string
      |> String.to_charlist()
      |> :little_lang_lexer.string()

    {:ok, tokens}
  end

  @spec tokenize!(string :: binary()) :: list()
  @doc """
  Lex a string of characters into an unwrapped list of tokens.
  """
  def tokenize!(string) do
    case tokenize(string) do
      {:ok, tokens} -> tokens
    end
  end
end
