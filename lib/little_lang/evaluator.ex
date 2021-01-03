defmodule LittleLang.Evaluator do
  @moduledoc """
  Evaluates a list of instructions and returns a boolean.

  This is a stack machine.
  """

  @type bool_or_undefined :: boolean() | :undefined

  @default_external_functions LittleLang.ExternalFunctions
  @undefined :undefined

  defstruct [
    :instructions,
    :instructions_length,
    :processing,
    instruction_pointer: 0,
    context: %{},
    stack: []
  ]

  defguard is_undefined?(value) when value == @undefined

  defguard types_match?(a, b)
           when (is_integer(a) and is_integer(b)) or
                  (is_boolean(a) and is_boolean(b)) or
                  (is_binary(a) and is_binary(b))

  @spec build_context(map :: Map.t()) :: Map.t()
  @doc """
  Returns the default context with globals merged onto the provided map.
  """
  def build_context(map \\ %{}) do
    Map.merge(map, %{
      "true" => true,
      "false" => false,
      "undefined" => @undefined
    })
  end

  @doc """
  Creates a new struct based on the provided instructions and context.
  """
  def new(instructions, context \\ %{}) when is_list(instructions) and is_map(context) do
    %__MODULE__{
      context: build_context(context),
      instructions: instructions,
      instructions_length: length(instructions)
    }
  end

  @spec process(instructions :: list()) :: bool_or_undefined
  @doc """
  Evaluate the list of instructions and returns a boolean
  """
  def process(instructions, context \\ %{}) when is_list(instructions) and is_map(context) do
    instructions
    |> new(context)
    |> process_next_instruction()
  end

  # add
  #
  # Pops the top two values from the stack to add.
  # If either one is undefined, or if the types don't match then pushes undefined on the stack.
  # Otherwise add the two values and push the boolean on the stack.
  def process_instruction(
        %__MODULE__{processing: ["add"], stack: [right | [left | sub_stack]]} = evaluator
      )
      when is_undefined?(right) or is_undefined?(left) do
    %__MODULE__{evaluator | stack: [@undefined | sub_stack]}
  end

  def process_instruction(
        %__MODULE__{processing: ["add"], stack: [right | [left | sub_stack]]} = evaluator
      )
      when types_match?(left, right) do
    %__MODULE__{evaluator | stack: [left + right | sub_stack]}
  end

  def process_instruction(
        %__MODULE__{processing: ["add"], stack: [_right | [_left | sub_stack]]} = evaluator
      ) do
    %__MODULE__{evaluator | stack: [@undefined | sub_stack]}
  end

  # subtract
  #
  # Pops the top two values from the stack to subtract.
  # If either one is undefined, or if the types don't match then pushes undefined on the stack.
  # Otherwise subtract right from left and push the boolean on the stack.
  def process_instruction(
        %__MODULE__{processing: ["subtract"], stack: [right | [left | sub_stack]]} = evaluator
      )
      when is_undefined?(right) or is_undefined?(left) do
    %__MODULE__{evaluator | stack: [@undefined | sub_stack]}
  end

  def process_instruction(
        %__MODULE__{processing: ["subtract"], stack: [right | [left | sub_stack]]} = evaluator
      )
      when types_match?(left, right) do
    %__MODULE__{evaluator | stack: [left - right | sub_stack]}
  end

  def process_instruction(
        %__MODULE__{processing: ["subtract"], stack: [_right | [_left | sub_stack]]} = evaluator
      ) do
    %__MODULE__{evaluator | stack: [@undefined | sub_stack]}
  end

  # compare EQ
  #
  # Pops the top two values from the stack to compare.
  # If either one is undefined, or if the types don't match then pushes undefined on the stack.
  # Otherwise compare equality and push the boolean on the stack.
  def process_instruction(
        %__MODULE__{processing: ["compare", "EQ"], stack: [right | [left | sub_stack]]} =
          evaluator
      )
      when is_undefined?(right) or is_undefined?(left) do
    %__MODULE__{evaluator | stack: [@undefined | sub_stack]}
  end

  def process_instruction(
        %__MODULE__{processing: ["compare", "EQ"], stack: [right | [left | sub_stack]]} =
          evaluator
      )
      when types_match?(left, right) do
    compare_result = left == right

    %__MODULE__{evaluator | stack: [compare_result | sub_stack]}
  end

  def process_instruction(
        %__MODULE__{processing: ["compare", "EQ"], stack: [_right | [_left | sub_stack]]} =
          evaluator
      ) do
    %__MODULE__{evaluator | stack: [@undefined | sub_stack]}
  end

  # call
  #
  # Call the external function named in the instruction and use the top
  # Otherwise remove the top of the stack
  def process_instruction(
        %__MODULE__{
          processing: ["call", function, arity],
          stack: stack
        } = evaluator
      ) do
    {arguments, sub_stack} = Enum.split(stack, arity)

    call_result = apply(external_functions(), String.to_existing_atom(function), arguments)

    %__MODULE__{evaluator | stack: [call_result | sub_stack]}
  end

  # jtrue
  #
  # If the top of the stack is true, increase the instruction_pointer by count
  # Otherwise remove the top of the stack
  def process_instruction(
        %__MODULE__{
          processing: ["jtrue", count],
          instruction_pointer: ip,
          stack: [true | _rest]
        } = evaluator
      ) do
    %__MODULE__{evaluator | instruction_pointer: ip + count}
  end

  def process_instruction(
        %__MODULE__{processing: ["jtrue", _count], stack: [_top | rest_of_stack]} = evaluator
      ) do
    %__MODULE__{evaluator | stack: rest_of_stack}
  end

  # minus
  #
  # If the top of the stack is a number, replace it with the inverse (value multiplied by -1).
  # Otherwise replace it with undefined
  def process_instruction(
        %__MODULE__{processing: ["minus"], stack: [top | rest_of_stack]} = evaluator
      )
      when is_integer(top) do
    %__MODULE__{evaluator | stack: [top * -1 | rest_of_stack]}
  end

  def process_instruction(
        %__MODULE__{processing: ["minus"], stack: [_invalid_top | rest_of_stack]} = evaluator
      ) do
    %__MODULE__{evaluator | stack: [@undefined | rest_of_stack]}
  end

  # not
  #
  # If the top of the stack is a boolean, replace it with the inverse.
  # Otherwise replace it with undefined
  def process_instruction(
        %__MODULE__{processing: ["not"], stack: [top | rest_of_stack]} = evaluator
      )
      when is_boolean(top) do
    %__MODULE__{evaluator | stack: [!top | rest_of_stack]}
  end

  def process_instruction(
        %__MODULE__{processing: ["not"], stack: [_invalid_top | rest_of_stack]} = evaluator
      ) do
    %__MODULE__{evaluator | stack: [@undefined | rest_of_stack]}
  end

  # lit
  #
  # Push the literal provided onto the stack.
  def process_instruction(%__MODULE__{processing: ["lit", literal], stack: stack} = evaluator) do
    %__MODULE__{evaluator | stack: [literal | stack]}
  end

  # load
  #
  # Load the identifier from the context and push it onto the stack.
  # If the key doesn't exist, or the value returned is nil, push undefined onto the stack.
  def process_instruction(
        %__MODULE__{processing: ["load", identifier], context: context, stack: stack} = evaluator
      ) do
    value =
      load_from_context(context, identifier)
      |> case do
        nil -> @undefined
        val -> val
      end

    %__MODULE__{evaluator | stack: [value | stack]}
  end

  # bool_expr
  #
  # If the top of the stack is a boolean, that will be used as the final value
  def process_instruction(
        %__MODULE__{processing: ["bool_expr"], stack: [head | _rest]} = evaluator
      )
      when is_boolean(head),
      do: evaluator

  # The top of the stack is NOT a boolean - replace with undefined
  def process_instruction(
        %__MODULE__{processing: ["bool_expr"], stack: [_invalid_head | rest]} = evaluator
      ) do
    # do nothing for now
    %__MODULE__{evaluator | stack: [@undefined | rest]}
  end

  # === Private helpers

  # Done processing instructions - return the top of the stack
  defp process_next_instruction(%__MODULE__{
         instruction_pointer: ip,
         instructions_length: num_instructions,
         stack: [head | _rest]
       })
       when ip == num_instructions,
       do: head

  defp process_next_instruction(%__MODULE__{} = evaluator) do
    evaluator
    |> put_next_instruction()
    |> process_instruction()
    |> increment_pointer()
    |> process_next_instruction()
  end

  defp increment_pointer(%__MODULE__{instruction_pointer: ip} = evaluator, amount \\ 1) do
    %__MODULE__{evaluator | instruction_pointer: ip + amount}
  end

  defp put_next_instruction(
         %__MODULE__{
           instructions: instructions,
           instruction_pointer: ip
         } = evaluator
       ) do
    next_instruction = Enum.at(instructions, ip)

    %__MODULE__{evaluator | processing: next_instruction}
  end

  def peek(%__MODULE__{stack: []}), do: nil
  def peek(%__MODULE__{stack: [head | _tail]}), do: head

  defp load_from_context(context, identifier), do: Map.get(context, identifier)

  defp external_functions(), do: @default_external_functions
end
