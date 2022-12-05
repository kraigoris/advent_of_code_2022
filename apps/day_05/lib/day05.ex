defmodule Day05 do
  def part1() do
    [map, moves] = get_processed_input()

    map
    |> move_crates(moves, &move_by_one/4)
    |> scrap_top_crates()
  end

  def part2() do
    [map, moves] = get_processed_input()

    map
    |> move_crates(moves, &move_multiple/4)
    |> scrap_top_crates()
  end

  def scrap_top_crates(map) do
    map
    |> Enum.map(&List.last(elem(&1, 1)))
    |> Enum.filter(&(not is_nil(&1)))
    |> Enum.join("")
  end

  def get_processed_input() do
    get_input()
    |> String.trim_trailing()
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n"))
    |> then(&parse_map_and_moves/1)
  end

  def parse_map_and_moves([map_lines, moves_lines]) do
    map = parse_map(map_lines)
    moves = parse_moves(moves_lines)
    [map, moves]
  end

  def move_crates(map, instructions, mover) do
    Enum.reduce(instructions, map, fn move, new_map ->
      mover.(new_map, move.count, move.from, move.to)
    end)
  end

  def move_by_one(map, count, from, to) do
    Enum.reduce(Range.new(1, count), map, fn _iteration, new_map ->
      new_map
      |> Map.put(to, new_map[to] ++ [List.last(new_map[from])])
      |> Map.put(from, Enum.take(new_map[from], Enum.count(new_map[from]) - 1))
    end)
  end

  def move_multiple(map, count, from, to) do
    take_from = Enum.count(map[from]) - count

    map
    |> Map.put(to, map[to] ++ Enum.slice(map[from], take_from..-1))
    |> Map.put(from, Enum.take(map[from], take_from))
  end

  def parse_moves(moves_lines) do
    Enum.map(moves_lines, &parse_move_instruction(&1))
  end

  def parse_move_instruction(str) do
    [_, count, _, from, _, to] = String.split(str)

    %{
      count: String.to_integer(count),
      from: String.to_integer(from),
      to: String.to_integer(to)
    }
  end

  def parse_map(map_lines) do
    map_lines
    |> Enum.map(&chunk_string(&1))
    |> Enum.take(Enum.count(map_lines) - 1)
    |> Enum.map(&normalize(&1))
    |> Enum.reverse()
    |> Enum.reduce(%{}, fn items, outer_acc ->
      Enum.reduce(Enum.with_index(items, 1), outer_acc, fn {item, index}, inner_acc ->
        if is_nil(item) do
          Map.put(inner_acc, index, inner_acc[index] || [])
        else
          Map.put(inner_acc, index, (inner_acc[index] || []) ++ [item])
        end
      end)
    end)
  end

  def chunk_string(str) do
    str
    |> String.graphemes()
    |> Enum.chunk_every(3, 4)
    |> Enum.map(&Enum.join(&1, ""))
  end

  def normalize(lst) do
    Enum.map(lst, fn item ->
      if item === "   ", do: nil, else: String.at(item, 1)
    end)
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
