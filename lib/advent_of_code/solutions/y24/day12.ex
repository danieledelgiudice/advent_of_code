defmodule AdventOfCode.Solutions.Y24.Day12 do
  alias AoC.Input

  @deltas [{1, 0}, {0, 1}, {-1, 0}, {0, -1}]

  @corners_dirs [
    # top, left and top-left
    {{0, -1}, {-1, 0}, {-1, -1}},
    # top, right and top-right
    {{0, -1}, {1, 0}, {1, -1}},
    # bottom, left and bottom-left
    {{0, 1}, {-1, 0}, {-1, 1}},
    # bottom, right and bottom-right
    {{0, 1}, {1, 0}, {1, 1}}
  ]

  def parse(input, _part) do
    rows =
      Input.read!(input)
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    for {row, y} <- Enum.with_index(rows),
        {plant, x} <- Enum.with_index(row),
        into: %{} do
      {{x, y}, String.to_atom(plant)}
    end
  end

  defp neighbors({x, y}) do
    @deltas
    |> Enum.map(fn {dx, dy} ->
      {x + dx, y + dy}
    end)
  end

  defp step(available, {current_pos, current_plant}, acc) do
    neighbors(current_pos)
    |> Enum.map(&{&1, available[&1]})
    |> Enum.filter(fn {_, plant} -> plant == current_plant end)
    |> Enum.reduce(
      {acc, available},
      fn {pos, plant}, {paths, available} ->
        step(
          Map.delete(available, pos),
          {pos, plant},
          MapSet.put(paths, pos)
        )
      end
    )
  end

  defp area(region), do: Enum.count(region)

  defp perimeter(region) do
    insides =
      region
      |> Enum.map(fn pos ->
        neighbors(pos)
        |> Enum.count(fn neighbor ->
          neighbor in region
        end)
      end)
      |> Enum.sum()

    4 * Enum.count(region) - insides
  end

  defp score_one(region) do
    area(region) * perimeter(region)
  end

  defp find_regions(map) do
    Stream.unfold(map, fn
      acc when acc == %{} ->
        nil

      acc ->
        first = Enum.at(acc, 0)
        {pos, _} = first

        step(
          Map.delete(acc, pos),
          first,
          MapSet.new([pos])
        )
    end)
    |> Enum.to_list()
  end

  defp score_two(region) do
    area(region) * count_corners(region)
  end

  defp count_corners(region) do
    region
    |> Enum.map(&count_corners(region, &1))
    |> Enum.sum()
  end

  # got a little help from r/adventofcode for this
  # wasn't sure how to do it, but after looking at it's pretty simple
  defp count_corners(region, pos) do
    @corners_dirs
    |> Enum.count(fn {d_o1, d_o2, d_diag} ->
      # orthogonal 1
      o1 = apply_delta(pos, d_o1)
      # orthorgonal 2
      o2 = apply_delta(pos, d_o2)
      # diagonal
      diag = apply_delta(pos, d_diag)

      # Convex corner: both orthogonals
      convex_corner = o1 not in region and o2 not in region

      # Concave corner: both adjacents match group AND diagonal is different
      concave_corner = o1 in region and o2 in region and diag not in region

      convex_corner or concave_corner
    end)
  end

  defp apply_delta({x, y}, {dx, dy}), do: {x + dx, y + dy}

  def part_one(map) do
    find_regions(map)
    |> Enum.map(&score_one/1)
    |> Enum.sum()
  end

  def part_two(map) do
    find_regions(map)
    |> Enum.map(&score_two/1)
    |> Enum.sum()
  end
end
