defmodule LittleLang do
  @moduledoc """
  Documentation for `LittleLang`.
  """

  alias __MODULE__.Evaluator
  alias __MODULE__.Lexer
  alias __MODULE__.Parser
  alias __MODULE__.Visitors.InstructionsVisitor

  @doc """
  Compiles and evaluates the provided string.

  ## Examples

      iex> LittleLang.evaluate("(3 - 4) = -1")
      true

  """
  def evaluate(string, context \\ %{}) do
    string
    |> Lexer.process!()
    |> Parser.process!()
    |> InstructionsVisitor.accept()
    |> Evaluator.process(context)
  end
end
