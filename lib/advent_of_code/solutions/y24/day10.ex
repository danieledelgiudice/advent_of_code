defmodule AdventOfCode.Solutions.Y24.Day10 do
  alias AoC.Input

  def parse(input, _part) do
    rows =
      Input.read!(input)
      |> String.split("\n")

    for {row, y} <- Enum.with_index(rows),
        {h, x} <- Enum.with_index(String.to_charlist(row)),
        into: %{} do
      {{x, y}, h - ?0}
    end
  end

  defp neighbors(map, {x, y}) do
    [{-1, 0}, {0, -1}, {1, 0}, {0, 1}]
    |> Enum.map(fn {dx, dy} ->
      pos = {x + dx, y + dy}
      {pos, map[pos]}
    end)
  end

  defp find_trails(_, {pos, 9}), do: [pos]

  defp find_trails(map, {pos, h}) do
    neighbors(map, pos)
    |> Enum.flat_map(fn
      n when elem(n, 1) == h + 1 -> find_trails(map, n)
      _ -> []
    end)
  end

  defp score_trailhead(map, pos) do
    find_trails(map, pos)
    |> MapSet.new()
    |> Enum.count()
  end

  def part_one(map) do
    map
    |> Enum.filter(fn {_, h} -> h == 0 end)
    |> Enum.map(&score_trailhead(map, &1))
    |> Enum.sum()
  end

  defp rate_trailhead(map, pos) do
    find_trails(map, pos)
    |> Enum.count()
  end

  def part_two(map) do
    map
    |> Enum.filter(fn {_, h} -> h == 0 end)
    |> Enum.map(&rate_trailhead(map, &1))
    |> Enum.sum()
  end
end
