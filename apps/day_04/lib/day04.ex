defmodule Day04 do
  def part1() do
    get_input_pairs()
    |> Stream.map(fn {r1, r2} -> MapSet.subset?(r1, r2) || MapSet.subset?(r2, r1) end)
    |> Stream.filter(& &1)
    |> Enum.count()
  end

  def part2() do
    get_input_pairs()
    |> Stream.map(fn {r1, r2} -> Enum.count(MapSet.intersection(r1, r2)) !== 0 end)
    |> Stream.filter(& &1)
    |> Enum.count()
  end

  def get_input_pairs() do
    get_input()
    |> String.trim()
    |> String.split("\n")
    |> Stream.map(&String.split(&1, ","))
    |> Stream.map(fn [r1, r2] -> {range_set_from_string(r1), range_set_from_string(r2)} end)
  end

  def get_input() do
    __ENV__.file
    |> Path.dirname()
    |> Path.join("..")
    |> Path.expand()
    |> Path.join("input.txt")
    |> File.read!()
  end

  def range_from_string(str) do
    [low_str, high_str] = String.split(str, "-")
    low = String.to_integer(low_str)
    high = String.to_integer(high_str)
    Range.new(low, high)
  end

  def range_set_from_string(str) do
    str
    |> range_from_string()
    |> Enum.to_list()
    |> MapSet.new()
  end
end
