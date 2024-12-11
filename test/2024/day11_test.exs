defmodule AdventOfCode.Solutions.Y24.Day11Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y24.Day11, as: Solution, warn: false
  use ExUnit.Case, async: true

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  test "part one example" do
    input = ~S"""
    125 17
    """

    assert 55312 == solve(input, :part_one)
  end

  @part_one_solution 193_899

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 11, :part_one)
  end

  test "part two example" do
    input = ~S"""
    125 17
    """

    assert 65_601_038_650_482 == solve(input, :part_two)
  end

  @part_two_solution 229_682_160_383_225

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 11, :part_two)
  end
end
