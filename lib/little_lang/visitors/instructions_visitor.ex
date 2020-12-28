defmodule LittleLang.Visitors.InstructionsVisitor do
  defstruct [:instructions]

  def accept(ast) do
    %{instructions: instructions} =
      %__MODULE__{instructions: []}
      |> visit(ast)

    instructions
  end

  defp visit(visitor, {:bool_expr, expr}) do
    visitor = visit(visitor, expr)
    %__MODULE__{visitor | instructions: visitor.instructions ++ [["bool_expr"]]}
  end

  defp visit(visitor, {:expression, expr}) do
    visit(visitor, expr)
  end

  defp visit(visitor, {:unary_expr, expr}) do
    visit(visitor, expr)
  end

  defp visit(visitor, {:basic_expr, expr}) do
    visit(visitor, expr)
  end

  defp visit(
         %__MODULE__{instructions: instructions} = visitor,
         {:identifier, identifier}
       ) do
    %__MODULE__{visitor | instructions: instructions ++ [["load", identifier]]}
  end

  defp visit(visitor, {:not_, unary_expr, {_unary_op, _string}}) do
    visitor = visit(visitor, unary_expr)
    %__MODULE__{visitor | instructions: visitor.instructions ++ [["not"]]}
  end
end
