defmodule LittleLang.Evaluator do
  @moduledoc """
  Evaluates a list of instructions and returns a boolean.

  This is a stack machine.
  """

  @type bool_or_undefined :: boolean() | :undefined

  defstruct [
    :instructions,
    :instructions_length,
    :processing,
    instruction_pointer: 0,
    context: %{},
    stack: []
  ]

  @spec default_context() :: Map.t()
  @doc """
  Returns the default context with globals added
  """
  def default_context() do
    %{
      "true" => true,
      "false" => false
    }
  end

  @spec process(instructions :: list()) :: bool_or_undefined
  @doc """
  Evaluate the list of instructions and returns a boolean
  """
  def process(instructions) when is_list(instructions) do
    %__MODULE__{
      context: default_context(),
      instructions: instructions,
      instructions_length: length(instructions)
    }
    |> process_next_instruction()
  end

  def process_instruction(
        %__MODULE__{processing: ["load", identifier], context: context, stack: stack} = evaluator
      ) do
    value = load_from_context(context, identifier)
    %__MODULE__{evaluator | stack: [value | stack]}
  end

  def process_instruction(
        %__MODULE__{processing: ["bool_expr"], stack: [_bool | _rest]} = evaluator
      ) do
    # do nothing for now
    evaluator
  end

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
