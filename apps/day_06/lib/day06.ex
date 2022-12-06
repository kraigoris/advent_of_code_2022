defmodule Day06 do
  def part1() do
    get_input()
    |> String.trim()
    |> String.graphemes()
    |> Enum.reduce_while({[], 1}, fn char, {window, current_index} ->
      new_window = slide4(window, char)

      if is_packet_marker?(new_window) do
        {:halt, {new_window, current_index}}
      else
        {:cont, {new_window, current_index + 1}}
      end
    end)
    |> elem(1)
  end

  def part2() do
    get_input()
    |> String.trim()
    |> String.graphemes()
    |> Enum.reduce_while({[], 1}, fn char, {window, current_index} ->
      new_window = slide14(window, char)

      if is_message_marker?(new_window) do
        {:halt, {new_window, current_index}}
      else
        {:cont, {new_window, current_index + 1}}
      end
    end)
    |> elem(1)
  end

  def is_message_marker?(lst) when length(lst) === 14, do: Enum.count(Enum.uniq(lst)) === 14
  def is_message_marker?(_lst), do: false

  def is_packet_marker?(lst) when length(lst) === 4, do: Enum.count(Enum.uniq(lst)) === 4
  def is_packet_marker?(_lst), do: false

  def slide14([], new_elem), do: [new_elem]
  def slide14([_ | rest] = lst, new_elem) when length(lst) == 14, do: rest ++ [new_elem]
  def slide14(lst, new_elem), do: lst ++ [new_elem]

  def slide4([], new_elem), do: [new_elem]
  def slide4([_ | rest] = lst, new_elem) when length(lst) == 4, do: rest ++ [new_elem]
  def slide4(lst, new_elem), do: lst ++ [new_elem]

  def get_input() do
    __ENV__.file
    |> Path.dirname()
    |> Path.join("..")
    |> Path.expand()
    |> Path.join("input.txt")
    |> File.read!()
  end
end
