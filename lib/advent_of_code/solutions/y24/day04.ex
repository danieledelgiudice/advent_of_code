defmodule AdventOfCode.Solutions.Y24.Day04 do
  alias AoC.Input

  @part_one_dirs [
    # ➡️
    [{0, 0}, {1, 0}, {2, 0}, {3, 0}],
    # ↘️
    [{0, 0}, {1, 1}, {2, 2}, {3, 3}],
    # ⬇️
    [{0, 0}, {0, 1}, {0, 2}, {0, 3}],
    # ↙️
    [{0, 0}, {-1, 1}, {-2, 2}, {-3, 3}],
    # ⬅️
    [{0, 0}, {-1, 0}, {-2, 0}, {-3, 0}],
    # ↖️
    [{0, 0}, {-1, -1}, {-2, -2}, {-3, -3}],
    # ⬆️
    [{0, 0}, {0, -1}, {0, -2}, {0, -3}],
    # ↗️
    [{0, 0}, {1, -1}, {2, -2}, {3, -3}]
  ]

  @part_two_dirs [
    [{0, 0}, {-1, -1}, {1, 1}, {1, -1}, {-1, 1}],
    [{0, 0}, {-1, -1}, {1, 1}, {-1, 1}, {1, -1}],
    [{0, 0}, {1, 1}, {-1, -1}, {1, -1}, {-1, 1}],
    [{0, 0}, {1, 1}, {-1, -1}, {-1, 1}, {1, -1}]
  ]

  def parse(input, _part) do
    chars =
      Input.read!(input)
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_charlist/1)

    for {row, y} <- Enum.with_index(chars),
        {char, x} <- Enum.with_index(row),
        into: %{} do
      {{x, y}, char}
    end
  end

  def part_one(problem) do
    for {{x, y}, ?X} <- problem,
        dir <- @part_one_dirs do
      for {dx, dy} <- dir, do: problem[{x + dx, y + dy}]
    end
    |> Enum.count(fn
      [?X, ?M, ?A, ?S] -> true
      _ -> false
    end)
  end

  def part_two(problem) do
    for {{x, y}, ?A} <- problem,
        dir <- @part_two_dirs do
      for {dx, dy} <- dir, do: problem[{x + dx, y + dy}]
    end
    |> Enum.count(fn
      [?A, ?M, ?S, ?M, ?S] -> true
      _ -> false
    end)
  end
end
