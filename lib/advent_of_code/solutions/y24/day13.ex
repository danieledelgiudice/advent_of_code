defmodule AdventOfCode.Solutions.Y24.Day13 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn machine ->
      [ax, ay, bx, by, cx, cy] =
        ~r/(\d+)/
        |> Regex.scan(machine, capture: :first)
        |> List.flatten()
        |> Enum.map(&String.to_integer/1)

      {
        {ax, ay},
        {bx, by},
        {cx, cy}
      }
    end)
  end

  defp solve({{ax, ay}, {bx, by}, {cx, cy}}) do
    # solve linear equation, trying to find two integer solutions
    det = ax * by - ay * bx

    if det == 0 do
      0
    else
      m = (by * cx - bx * cy) / det
      n = (-ay * cx + ax * cy) / det

      if trunc(m) == m and trunc(n) == n do
        # the score is 3 * m + n
        trunc(3 * m + n)
      else
        0
      end
    end
  end

  def part_one(machines) do
    machines
    |> Enum.map(&solve/1)
    |> Enum.sum()
  end

  def part_two(machines) do
    inc = 10_000_000_000_000

    machines
    |> Enum.map(fn {a, b, {cx, cy}} ->
      {a, b, {cx + inc, cy + inc}}
    end)
    |> Enum.map(&solve/1)
    |> Enum.sum()
  end
end
