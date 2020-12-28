defmodule LittleLang.Evaluator do
  @moduledoc """
  Evaluates a list of instructions and returns a boolean.

  This is a stack machine.
  """

  @type bool_or_undefined :: boolean() | :undefined

  @undefined :undefined

  defstruct [
    :instructions,
    :instructions_length,
    :processing,
    instruction_pointer: 0,
    context: %{},
    stack: []
  ]

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
    %__MODULE__{evaluator | stack: [:undefined | rest_of_stack]}
  end

  # Load the identifier from the context and push it onto the stack
  def process_instruction(
        %__MODULE__{processing: ["load", identifier], context: context, stack: stack} = evaluator
      ) do
    value = load_from_context(context, identifier)
    %__MODULE__{evaluator | stack: [value | stack]}
  end

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

  defp load_from_context(context, identifier) do
    Map.get(context, identifier)
  end
end