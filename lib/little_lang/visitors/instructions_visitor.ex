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

  defp visit(visitor, {:binary_expr, {:or, _image}, left, right}) do
    left_visitor = visit(visitor, left)

    %__MODULE__{
      left_visitor
      | instructions:
          left_visitor.instructions ++ [["jtrue", num_instructions(left_visitor, right)]]
    }
    |> visit(right)
  end

  defp visit(visitor, {:binary_expr, {:equals, _image}, left, right}) do
    visited =
      visitor
      |> visit(left)
      |> visit(right)

    %__MODULE__{
      visited
      | instructions: visited.instructions ++ [["compare", "EQ"]]
    }
  end

  defp visit(visitor, {:binary_expr, {:plus, _image}, left, right}) do
    visited =
      visitor
      |> visit(left)
      |> visit(right)

    %__MODULE__{
      visited
      | instructions: visited.instructions ++ [["add"]]
    }
  end

  defp visit(visitor, {:binary_expr, {:minus, _image}, left, right}) do
    visited =
      visitor
      |> visit(left)
      |> visit(right)

    %__MODULE__{
      visited
      | instructions: visited.instructions ++ [["subtract"]]
    }
  end

  defp visit(
         %__MODULE__{instructions: instructions} = visitor,
         {lit_type, lit_value}
       )
       when lit_type in [:bool_lit, :int_lit, :string_lit] do
    %__MODULE__{visitor | instructions: instructions ++ [["lit", lit_value]]}
  end

  defp visit(
         %__MODULE__{instructions: instructions} = visitor,
         {:identifier, identifier}
       ) do
    %__MODULE__{visitor | instructions: instructions ++ [["load", identifier]]}
  end

  defp visit(visitor, {:unary_expr, {unary_op, _image}, unary_expr})
       when unary_op in [:bang, :not] do
    visitor = visit(visitor, unary_expr)
    %__MODULE__{visitor | instructions: visitor.instructions ++ [["not"]]}
  end

  defp visit(visitor, {:unary_expr, {:minus, _image}, unary_expr}) do
    visitor = visit(visitor, unary_expr)
    %__MODULE__{visitor | instructions: visitor.instructions ++ [["minus"]]}
  end

  defp visit(visitor, {:group_expr, expression}) do
    visit(visitor, expression)
  end

  defp visit(visitor, {:call_expr, {:identifier, function}, arguments}) do
    visitor =
      arguments
      |> Enum.reduce(visitor, fn arg, acc ->
        visit(acc, arg)
      end)

    %__MODULE__{
      visitor
      | instructions: visitor.instructions ++ [["call", function, length(arguments)]]
    }
  end

  defp visit(visitor, {:list_expr, expressions}) do
    visitor_with_empty_list = %__MODULE__{
      visitor
      | instructions: visitor.instructions ++ [["lit", []]]
    }

    expressions
    |> Enum.reduce(visitor_with_empty_list, fn arg, acc ->
      vis = visit(acc, arg)

      %__MODULE__{
        vis
        | instructions: vis.instructions ++ [["append"]]
      }
    end)
  end

  defp num_instructions(visitor, ast) do
    count_visitor = visit(visitor, ast)
    length(count_visitor.instructions) - length(visitor.instructions)
  end
end
