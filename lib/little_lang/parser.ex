defmodule LittleLang.Parser do
  @moduledoc """
  Parses a list of tokens into an Abstract Syntax Tree.
  """

  alias LittleLang.Lexer

  @spec parse(tokens :: list()) :: map()
  @doc """
  Parse the input into an Abstract Syntax Tree.
  """
  def parse(input) when is_binary(input) do
    input
    |> Lexer.tokenize!()
    |> parse()
  end

  def parse(input) when is_list(input) do
    input
    |> :little_lang_parser.parse()
  end
end
