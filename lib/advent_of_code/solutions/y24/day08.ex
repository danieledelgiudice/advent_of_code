defmodule AdventOfCode.Solutions.Y24.Day08 do
  alias AoC.Input

  def parse(input, _part) do
    rows =
      Input.read!(input)
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_charlist/1)

    map =
      for {row, y} <- Enum.with_index(rows),
          {freq, x} <- Enum.with_index(row),
          freq != ?. do
        {freq, {x, y}}
      end
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
      |> Map.values()

    size = length(rows)

    {map, size}
  end

  def find_antinodes_one(positions) do
    for {{ax, ay}, ia} <- Enum.with_index(positions),
        {{bx, by}, ib} <- Enum.with_index(positions),
        ia < ib do
      {dx, dy} = {bx - ax, by - ay}

      [
        {ax - dx, ay - dy},
        {bx + dx, by + dy}
      ]
    end
    |> List.flatten()
  end

  def find_antinodes_two(positions, size) do
    for {{ax, ay}, ia} <- Enum.with_index(positions),
        {{bx, by}, ib} <- Enum.with_index(positions),
        ia < ib do
      {dx, dy} = {bx - ax, by - ay}

      # good enough
      times = size

      [
        Enum.map(0..times, fn t ->
          {ax - t * dx, ay - t * dy}
        end),
        Enum.map(0..times, fn t ->
          {bx + t * dx, by + t * dy}
        end)
      ]
    end
    |> List.flatten()
    |> Enum.filter(&in_map?(&1, size))
  end

  def in_map?({x, y}, size) do
    x >= 0 and y >= 0 and x < size and y < size
  end

  def part_one({map, size}) do
    map
    |> Enum.flat_map(&find_antinodes_one/1)
    |> Enum.filter(&in_map?(&1, size))
    |> MapSet.new()
    |> Enum.count()
  end

  def part_two({map, size}) do
    map
    |> Enum.flat_map(&find_antinodes_two(&1, size))
    |> Enum.filter(&in_map?(&1, size))
    |> MapSet.new()
    |> Enum.count()
  end
end
