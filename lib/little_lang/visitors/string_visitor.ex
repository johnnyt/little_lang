defmodule LittleLang.Visitors.StringVisitor do
  def accept(ast) do
    visit(ast)
  end

  defp visit({:bool_expr, expression}) do
    visit(expression)
  end

  defp visit({:binary_expr, {_op_type, op_image}, left, right}) do
    "#{visit(left)} #{op_image} #{visit(right)}"
  end

  defp visit({:group_expr, expression}) do
    "(#{visit(expression)})"
  end

  defp visit({:bool_lit, bool}) do
    "#{bool}"
  end

  defp visit({:int_lit, int}) do
    "#{int}"
  end

  defp visit({:string_lit, string}) do
    ~s["#{string}"]
  end

  defp visit({:identifier, identifier_image}) do
    identifier_image
  end

  defp visit({:unary_expr, {:bang, not_image}, unary_expr}) do
    "#{not_image}#{visit(unary_expr)}"
  end

  defp visit({:unary_expr, {:minus, minus_image}, unary_expr}) do
    "#{minus_image}#{visit(unary_expr)}"
  end

  defp visit({:unary_expr, {:not, not_image}, unary_expr}) do
    "#{not_image} #{visit(unary_expr)}"
  end

  defp visit({:call_expr, function, arguments}) do
    argument_strings =
      arguments
      |> Enum.map(fn arg -> visit(arg) end)

    "#{visit(function)}(#{Enum.join(argument_strings, ", ")})"
  end

  defp visit({:list_expr, expressions}) do
    expression_strings =
      expressions
      |> Enum.map(fn arg -> visit(arg) end)

    "[#{Enum.join(expression_strings, ", ")}]"
  end
end
