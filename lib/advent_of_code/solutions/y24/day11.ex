defmodule AdventOfCode.Solutions.Y24.Day11 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.trim()
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
  end

  defp blink(0), do: [1]

  defp blink(n) do
    digits = Integer.digits(n)
    count = length(digits)

    cond do
      rem(count, 2) == 0 ->
        digits
        |> Enum.split(div(count, 2))
        |> Tuple.to_list()
        |> Enum.map(&Integer.undigits/1)

      true ->
        [n * 2024]
    end
  end

  defp blink_all(stones) do
    stones
    |> Enum.flat_map(fn {n, count} ->
      blink(n) |> Enum.map(&{&1, count})
    end)
    |> Enum.reduce(%{}, fn {new_key, count}, acc ->
      Map.update(acc, new_key, count, &(&1 + count))
    end)
  end

  defp score(stones) do
    stones
    |> Map.values()
    |> Enum.sum()
  end

  defp solve(stones, steps) do
    Stream.iterate(stones, &blink_all/1)
    |> Enum.at(steps)
    |> score()
  end

  def part_one(stones) do
    solve(stones, 25)
  end

  def part_two(stones) do
    solve(stones, 75)
  end
end
