defmodule Day06 do
  def part1() do
    get_characters()
    |> traverse_char_list(4)
    |> elem(1)
  end

  def part2() do
    get_characters()
    |> traverse_char_list(14)
    |> elem(1)
  end

  def traverse_char_list(lst, marker_size) do
    Enum.reduce_while(lst, {[], 1}, fn char, {window, current_index} ->
      new_window = slide(window, char, marker_size)

      if is_marker?(new_window, marker_size) do
        {:halt, {new_window, current_index}}
      else
        {:cont, {new_window, current_index + 1}}
      end
    end)
  end

  def is_marker?(lst, size), do: Enum.count(Enum.uniq(lst)) === size

  def slide(lst, new_elem, window_size) do
    case lst do
      [] -> [new_elem]
      [_ | rest] when length(lst) === window_size -> rest ++ [new_elem]
      lst -> lst ++ [new_elem]
    end
  end

  def get_characters() do
    get_input()
    |> String.trim()
    |> String.graphemes()
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
