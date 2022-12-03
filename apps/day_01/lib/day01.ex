defmodule Day01 do
  def part1() do
    get_calories_sets()
    |> Enum.map(&Enum.sum(&1))
    |> Enum.max()
  end

  def part2() do
    get_calories_sets()
    |> Enum.map(&Enum.sum(&1))
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end

  def get_calories_sets() do
    get_input()
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n"))
    |> Enum.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
  end

  def get_input() do
    __ENV__.file
    |> Path.dirname()
    |> Path.join("..")
    |> Path.expand()
    |> Path.join("input.txt")
    |> File.read!()
  end
end
