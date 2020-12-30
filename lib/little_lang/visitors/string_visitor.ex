defmodule LittleLang.Visitors.StringVisitor do
  def accept(ast) do
    visit(ast)
  end

  defp visit({:bool_expr, expression}) do
    visit(expression)
  end

  defp visit({:binary_expr, {_op_type, op_string}, left, right}) do
    "#{visit(left)} #{op_string} #{visit(right)}"
  end

  defp visit({:identifier, identifier}) do
    identifier
  end

  defp visit({:unary_expr, {:bang, not_string}, unary_expr}) do
    "#{not_string}#{visit(unary_expr)}"
  end

  defp visit({:unary_expr, {:not, not_string}, unary_expr}) do
    "#{not_string} #{visit(unary_expr)}"
  end

  defp visit({:call_expr, function, arguments}) do
    argument_strings =
      arguments
      |> Enum.map(fn arg -> visit(arg) end)

    "#{visit(function)}(#{Enum.join(argument_strings, ", ")})"
  end
end
