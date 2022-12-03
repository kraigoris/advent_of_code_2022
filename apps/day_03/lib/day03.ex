defmodule Day03 do
  def part1() do
    priorities = create_item_priority_map()

    get_input()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn items ->
      half_point = Kernel.trunc(Enum.count(items) / 2)

      items
      |> Enum.split(half_point)
      |> then(fn {a, b} ->
        intersection = MapSet.intersection(MapSet.new(a), MapSet.new(b))

        Enum.reduce(intersection, 0, fn i, acc -> priorities[i] + acc end)
      end)
    end)
    |> Enum.sum()
  end

  def part2() do
    priorities = create_item_priority_map()

    get_input()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.chunk_every(3)
    |> Enum.map(fn [a, b, c] ->
      a
      |> MapSet.new()
      |> MapSet.intersection(MapSet.new(b))
      |> MapSet.intersection(MapSet.new(c))
      |> Enum.to_list()
      |> List.first()
      |> then(fn badge -> priorities[badge] end)
    end)
    |> Enum.sum()
  end

  def get_input() do
    __ENV__.file
    |> Path.dirname()
    |> Path.join("..")
    |> Path.expand()
    |> Path.join("input.txt")
    |> File.read!()
  end

  def create_alphabet() do
    lowercase = Enum.to_list(?a..?z) |> List.to_string()
    uppercase = Enum.to_list(?A..?Z) |> List.to_string()
    lowercase <> uppercase
  end

  def create_item_priority_map() do
    create_alphabet()
    |> String.graphemes()
    |> Enum.with_index(1)
    |> Map.new()
  end
end
