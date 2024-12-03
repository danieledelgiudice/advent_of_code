defmodule AdventOfCode.Solutions.Y24.Day01 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      String.split(row)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def part_one(problem) do
    problem
    |> Enum.map(&Enum.sort/1)
    |> Enum.zip()
    |> Enum.map(fn {a, b} ->
      abs(a - b)
    end)
    |> Enum.sum()
  end

  def part_two(problem) do
    [as, bs] = problem
    freq = Enum.frequencies(bs)

    as
    |> Enum.map(fn a ->
      a * Map.get(freq, a, 0)
    end)
    |> Enum.sum()
  end
end
