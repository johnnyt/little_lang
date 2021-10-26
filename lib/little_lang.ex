defmodule LittleLang do
  @moduledoc """
  Documentation for `LittleLang`.
  """

  alias __MODULE__.Evaluator
  alias __MODULE__.Lexer
  alias __MODULE__.Parser
  alias __MODULE__.Visitors.InstructionsVisitor
  alias __MODULE__.Visitors.StringVisitor

  @doc """
  Compiles and evaluates the provided string.

  ## Examples

      iex> LittleLang.evaluate("(3 - 4) = -1")
      true

  """
  def parse(string, _context \\ %{}) do
    string
    |> Lexer.process!()
    |> Parser.process!()
  end

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

  @doc """
  Parses the provided string and returns it formatted

  ## Examples

      iex> LittleLang.as_string("(3    -     4) = -1")
      "(3 - 4) = -1"

  """
  def as_string(string) do
    string
    |> Lexer.process!()
    |> Parser.process!()
    |> StringVisitor.accept()
  end

  @doc """
  Parses the provided string and returns the instructions

  ## Examples

      iex> LittleLang.compile("(3 - 4) = -1")

  """
  def compile(string) do
    string
    |> Lexer.process!()
    |> Parser.process!()
    |> InstructionsVisitor.accept()
  end
end
