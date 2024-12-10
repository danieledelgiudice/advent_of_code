defmodule AdventOfCode.Solutions.Y24.Day09 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
  end

  defp not_nil(x), do: not is_nil(x)

  def swap(map, i, j) do
    a = map[i]
    b = map[j]

    map
    |> Map.put(i, b)
    |> Map.put(j, a)
  end

  def parse_one(input) do
    input
    |> String.trim()
    |> String.to_charlist()
    |> Enum.map(&(&1 - ?0))
    |> Enum.chunk_every(2)
    |> Enum.with_index()
    |> Enum.flat_map(fn
      {[file, free], id} ->
        List.duplicate(id, file) ++ List.duplicate(nil, free)

      {[file], id} ->
        List.duplicate(id, file)
    end)
    |> Enum.with_index()
    |> Enum.map(fn {a, b} -> {b, a} end)
    |> Map.new()
  end

  def compact(map, first, last) when first >= last, do: map

  def compact(map, first, last) do
    a = map[first]
    b = map[last]

    cond do
      not_nil(a) ->
        compact(map, first + 1, last)

      is_nil(b) ->
        compact(map, first, last - 1)

      true ->
        map
        |> swap(first, last)
        |> compact(first, last)
    end
  end

  def score_one(map) do
    map
    |> Enum.map(fn
      {_, nil} -> 0
      {i, id} -> id * i
    end)
    |> Enum.sum()
  end

  def part_one(input) do
    map = parse_one(input)

    first = 0
    last = Enum.count(map) - 1

    map
    |> compact(first, last)
    |> score_one()
  end

  ######

  # Not really proud of this one
  # Might revisit later

  def part_two(input) do
    {free, used} = parse_two(input)

    used
    |> Enum.reverse()
    |> Enum.reduce({free, used}, fn block, {free, used} ->
      case find_fit(block, free) do
        nil ->
          {free, used}

        {dest, index} ->
          updated_free =
            List.replace_at(free, index, %{
              dest
              | size: dest.size - block.size,
                start: dest.start + block.size
            })

          updated_used =
            Enum.map(used, fn
              b when b.id == block.id -> %{b | start: dest.start}
              b -> b
            end)

          {updated_free, updated_used}
      end
    end)
    |> elem(1)
    |> score_two()
  end

  defp parse_two(input) do
    input
    |> String.trim()
    |> String.to_charlist()
    |> Enum.map(&(&1 - ?0))
    |> Enum.chunk_every(2)
    |> Enum.with_index()
    |> Enum.flat_map(fn
      {[used, free], id} ->
        [%{id: id, size: used, start: nil}, %{id: nil, size: free, start: nil}]

      {[used], id} ->
        [%{id: id, size: used, start: nil}]
    end)
    |> Enum.map_reduce(0, fn block, acc ->
      {Map.put(block, :start, acc), acc + block.size}
    end)
    |> elem(0)
    |> Enum.split_with(&is_nil(&1.id))
  end

  def score_two(used) do
    used
    |> Enum.reduce(0, fn %{id: id, start: start, size: size}, acc ->
      acc + id * (sum_range(start + size - 1) - sum_range(start - 1))
    end)
    |> trunc()
  end

  defp sum_range(n), do: div(n * (n + 1), 2)

  defp find_fit(block, free) do
    Enum.find_value(Enum.with_index(free), fn {%{size: size, start: start} = free_block, index} ->
      if size >= block.size and start < block.start, do: {free_block, index}
    end)
  end
end
