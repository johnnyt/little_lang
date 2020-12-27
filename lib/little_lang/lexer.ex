defmodule LittleLang.Lexer do
  @moduledoc """
  Module to lex a string of characters into a list of tokens.
  """

  @spec process(string :: binary()) :: {:ok, list()}
  @doc """
  Lex a string of characters into a list of tokens.
  """
  def process(string) do
    {:ok, tokens, _} =
      string
      |> String.to_charlist()
      |> :little_lang_lexer.string()

    {:ok, tokens}
  end

  @spec process!(string :: binary()) :: list()
  @doc """
  Lex a string of characters into an unwrapped list of tokens.
  """
  def process!(string) do
    case process(string) do
      {:ok, tokens} -> tokens
    end
  end
end
