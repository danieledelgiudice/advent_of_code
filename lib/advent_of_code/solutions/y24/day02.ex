defmodule AdventOfCode.Solutions.Y24.Day02 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn report ->
      String.split(report)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp safe?(report) do
    deltas =
      Enum.chunk_every(report, 2, 1, :discard)
      |> Enum.map(fn [a, b] -> a - b end)

    close = Enum.all?(deltas, &(abs(&1) in 1..3))
    inc = Enum.all?(deltas, &(&1 > 0))
    dec = Enum.all?(deltas, &(&1 < 0))

    close and (inc or dec)
  end

  def part_one(problem) do
    Enum.count(problem, &safe?/1)
  end

  def part_two(problem) do
    problem
    |> Enum.map(fn report ->
      case safe?(report) do
        true ->
          true

        false ->
          0..(length(report) - 1)
          |> Enum.map(&List.delete_at(report, &1))
          |> Enum.any?(&safe?/1)
      end
    end)
    |> Enum.count(&(&1 == true))
  end
end
