defmodule LittleLang.Visitors.InstructionsVisitor do
  defstruct [:instructions]

  def accept(ast) do
    %{instructions: instructions} =
      %__MODULE__{instructions: []}
      |> visit(ast)

    instructions
  end

  defp visit(visitor, {:bool_expr, expression}) do
    visit(visitor, expression)
  end

  defp visit(
         %__MODULE__{instructions: instructions} = visitor,
         {:expression, {:identifier, identifier}}
       ) do
    %__MODULE__{visitor | instructions: instructions ++ [["load", identifier], ["bool_expr"]]}
  end
end
