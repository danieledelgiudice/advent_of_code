defmodule AdventOfCode.Solutions.Y24.Day07 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.scan(~r/\d+/, &1))
    |> Enum.map(fn matches ->
      [target | xs] =
        matches
        |> Enum.map(fn [match] ->
          String.to_integer(match)
        end)

      {xs, target}
    end)
  end

  def part_one(equations) do
    equations
    |> Enum.filter(fn {xs, target} ->
      step_one(xs, target)
    end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def part_two(equations) do
    equations
    |> Enum.filter(fn {xs, target} ->
      step_two(xs, target)
    end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  defp step_one([target], target), do: true
  defp step_one([_], _), do: false

  defp step_one([acc | _], target) when acc > target, do: false

  defp step_one([acc, x | rest], target) do
    Enum.any?(
      [
        &add/2,
        &mul/2
      ],
      fn op ->
        step_one([op.(acc, x) | rest], target)
      end
    )
  end

  defp step_two([target], target), do: true
  defp step_two([_], _), do: false

  defp step_two([acc | _], target) when acc > target, do: false

  defp step_two([acc, x | rest], target) do
    Enum.any?(
      [
        &add/2,
        &mul/2,
        &concat/2
      ],
      fn op ->
        step_two([op.(acc, x) | rest], target)
      end
    )
  end

  defp add(x, y), do: x + y
  defp mul(x, y), do: x * y

  defp concat(x, y) do
    pow = Integer.digits(y) |> Enum.count()
    x * 10 ** pow + y
  end
end
