defmodule AdventOfCode.Solutions.Y24.Day05 do
  alias AoC.Input

  def parse(input, _part) do
    [rules, updates] =
      Input.read!(input)
      |> String.split("\n\n", trim: true)

    rules =
      rules
      |> String.split("\n", trim: true)
      |> Enum.map(fn pair ->
        String.split(pair, "|", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)
      |> MapSet.new()

    updates =
      updates
      |> String.split("\n", trim: true)
      |> Enum.map(fn update ->
        String.split(update, ",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    {rules, updates}
  end

  def part_one({rules, updates}) do
    updates
    |> Enum.map(fn update ->
      case sort_update(update, rules) do
        ^update -> take_median(update)
        _ -> 0
      end
    end)
    |> Enum.sum()
  end

  def part_two({rules, updates}) do
    updates
    |> Enum.map(fn update ->
      case sort_update(update, rules) do
        ^update -> 0
        changed -> take_median(changed)
      end
    end)
    |> Enum.sum()
  end

  defp sort_update(update, rules) do
    Enum.sort(update, fn first, second ->
      {first, second} in rules
    end)
  end

  defp take_median(update) do
    median = div(length(update), 2)
    Enum.at(update, median)
  end
end
