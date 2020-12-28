defmodule LittleLang.Lexer do
  @moduledoc """
  Module to lex a string of characters into a list of tokens.
  """

  @spec process(string :: binary()) :: {:ok, list()}
  @doc """
  Lex a string of characters into a list of tokens.
  """
  def process(string) do
    string
    |> String.to_charlist()
    |> :little_lang_lexer.string()
    |> case do
      {:ok, tokens, _} ->
        {:ok, tokens}

      {:error, {line, _lexer, {:illegal, char}}, _} ->
        {:error, :invalid_char, "Invalid character '#{char}' found on line #{line}"}
    end
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
