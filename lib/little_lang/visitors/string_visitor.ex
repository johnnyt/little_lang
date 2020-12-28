defmodule LittleLang.Visitors.StringVisitor do
  def accept(ast) do
    visit(ast)
  end

  defp visit({:bool_expr, expression}) do
    visit(expression)
  end

  defp visit({:expression, {:unary_expr, unary_expr}}) do
    visit(unary_expr)
  end

  defp visit({:unary_expr, {:basic_expr, basic_expr}}) do
    visit(basic_expr)
  end

  defp visit({:basic_expr, {:identifier, identifier}}) do
    identifier
  end
end
