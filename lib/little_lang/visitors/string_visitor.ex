defmodule LittleLang.Visitors.StringVisitor do
  def accept(ast) do
    visit(ast)
  end

  defp visit({:bool_expr, expression}) do
    visit(expression)
  end

  defp visit({:expression, expr}) do
    visit(expr)
  end

  defp visit({:unary_expr, expr}) do
    visit(expr)
  end

  defp visit({:basic_expr, expr}) do
    visit(expr)
  end

  defp visit({:identifier, identifier}) do
    identifier
  end

  defp visit({:not_, unary_expr, {:bang, not_string}}) do
    "#{not_string}#{visit(unary_expr)}"
  end

  defp visit({:not_, unary_expr, {:not_, not_string}}) do
    "#{not_string} #{visit(unary_expr)}"
  end
end
