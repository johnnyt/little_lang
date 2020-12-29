defmodule LittleLang.Visitors.StringVisitor do
  def accept(ast) do
    visit(ast)
  end

  defp visit({:bool_expr, expression}) do
    visit(expression)
  end

  # Unary Expr
  defp visit({:expression, expr}) do
    visit(expr)
  end

  # Binary Expr
  defp visit({:expression, left, right, {_op_type, op_string}}) do
    "#{visit(left)} #{op_string} #{visit(right)}"
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

  defp visit({:not, unary_expr, {:bang, not_string}}) do
    "#{not_string}#{visit(unary_expr)}"
  end

  defp visit({:not, unary_expr, {:not, not_string}}) do
    "#{not_string} #{visit(unary_expr)}"
  end
end
