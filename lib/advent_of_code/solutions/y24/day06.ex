defmodule AdventOfCode.Solutions.Y24.Day06 do
  alias AoC.Input

  @guard_dirs %{?v => :down, ?< => :left, ?^ => :up, ?> => :right}

  def parse(input, _part) do
    grid =
      Input.read!(input)
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_charlist/1)

    height = length(grid)
    width = length(Enum.at(grid, 0))

    walls =
      for {row, y} <- Enum.with_index(grid),
          {?#, x} <- Enum.with_index(row),
          into: MapSet.new() do
        {x, y}
      end

    guard =
      for {row, y} <- Enum.with_index(grid),
          {cell, x} <- Enum.with_index(row),
          true == cell in ~c"<>^v" do
        %{pos: {x, y}, dir: @guard_dirs[cell]}
      end
      |> List.first()

    {guard, walls, {width, height}}
  end

  def print_map(%{pos: pos, dir: dir}, walls, {width, height}, visited \\ []) do
    for y <- 0..(height - 1) do
      for x <- 0..(width - 1) do
        cond do
          {x, y} in visited -> "X"
          {x, y} in walls -> "#"
          {x, y} == pos and dir == :up -> "^"
          {x, y} == pos and dir == :down -> "v"
          {x, y} == pos and dir == :left -> "<"
          {x, y} == pos and dir == :right -> ">"
          true -> "."
        end
      end
      |> Enum.join()
    end
    |> Enum.join("\n")
    |> IO.puts()
  end

  defp offset(:down), do: {0, 1}
  defp offset(:left), do: {-1, 0}
  defp offset(:up), do: {0, -1}
  defp offset(:right), do: {1, 0}

  defp turn(:up), do: :right
  defp turn(:right), do: :down
  defp turn(:down), do: :left
  defp turn(:left), do: :up

  defp next_pos(%{pos: {x, y}, dir: dir}) do
    {dx, dy} = offset(dir)
    {x + dx, y + dy}
  end

  defp turn_until_free(guard, walls) do
    next = next_pos(guard)

    if next in walls do
      guard = %{guard | dir: turn(guard.dir)}
      turn_until_free(guard, walls)
    else
      guard
    end
  end

  defp out?(%{pos: {x, y}}, {width, height}) do
    x < 0 or y < 0 or x >= width or y >= height
  end

  defp walk(guard) do
    %{guard | pos: next_pos(guard)}
  end

  def step(guard, walls) do
    guard
    |> turn_until_free(walls)
    |> walk()
  end

  def part_one({guard, walls, size}) do
    guard
    |> Stream.unfold(fn guard ->
      if out?(guard, size) do
        nil
      else
        guard = step(guard, walls)
        {guard.pos, guard}
      end
    end)
    |> MapSet.new()
    |> MapSet.put(guard.pos)
    |> Enum.count()
    |> then(&(&1 - 1))
  end

  defp is_loop(guard, walls, size, visited) do
    cond do
      out?(guard, size) ->
        false

      guard in visited ->
        true

      true ->
        visited = MapSet.put(visited, guard)
        guard = step(guard, walls)
        is_loop(guard, walls, size, visited)
    end
  end

  def part_two({guard, walls, {width, height} = size}) do
    for x <- 0..(width - 1),
        y <- 0..(height - 1) do
      {x, y}
    end
    |> Enum.filter(fn new_wall ->
      is_loop(
        guard,
        MapSet.put(walls, new_wall),
        size,
        MapSet.new()
      )
    end)
    |> Enum.count()
  end
end
