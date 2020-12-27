defmodule LittleLang.Parser do
  @moduledoc """
  Parses a list of tokens into an Abstract Syntax Tree.
  """

  alias LittleLang.Lexer

  @spec process(tokens :: list()) :: map()
  @doc """
  Parse the input into an Abstract Syntax Tree.
  """
  def process(input) when is_binary(input) do
    input
    |> Lexer.process!()
    |> process()
  end

  def process(input) when is_list(input) do
    input
    |> :little_lang_parser.parse()
  end
end
