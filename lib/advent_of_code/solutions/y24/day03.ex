defmodule AdventOfCode.Solutions.Y24.Day03 do
  alias AoC.Input

  def parse(input, part) do
    regex =
      case part do
        :part_one -> ~r/mul\((\d+),(\d+)\)/
        :part_two -> ~r/mul\((\d+),(\d+)\)|do\(\)|don't\(\)/
      end

    Input.read!(input)
    |> then(&Regex.scan(regex, &1))
  end

  def part_one(problem) do
    problem
    |> Enum.map(fn [_, a, b] ->
      String.to_integer(a) * String.to_integer(b)
    end)
    |> Enum.sum()
  end

  def part_two(problem) do
    problem
    |> Enum.reduce({[], :do}, fn
      ["don't()"], {acc, _} -> {acc, :dont}
      ["do()"], {acc, _} -> {acc, :do}
      _mul, {acc, :dont} -> {acc, :dont}
      mul, {acc, :do} -> {[mul | acc], :do}
    end)
    |> elem(0)
    |> part_one()
  end
end
