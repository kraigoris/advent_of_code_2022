defmodule Day08 do
  def part1() do
    get_input()
    |> sanitize_input()
    |> parse_zone()
    |> Enum.map(fn {_i, row} ->
      Enum.count(Enum.filter(row, fn {_j, tree} -> visible_from_outside?(tree) end))
    end)
    |> Enum.sum()
  end

  def part2() do
    get_input()
    |> sanitize_input()
    |> parse_zone()
    |> Enum.map(fn {_i, row} -> Enum.max(Enum.map(row, fn {_j, tree} -> tree.scenic_score end)) end)
    |> Enum.max()
  end

  def parse_zone(input) do
    input
    |> Enum.with_index()
    |> Enum.map(fn {row, i} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {item, j} -> {j, new_tree(item, i, j)} end)
      |> Map.new()
      |> then(fn row -> {i, row} end)
    end)
    |> Map.new()
    |> then(fn forest -> map_zone(forest, &update_safety(&1, forest)) end)
    |> then(fn forest -> map_zone(forest, &update_visibility(&1, forest)) end)
    |> then(fn forest -> map_zone(forest, &update_scenic_score(&1)) end)
  end

  def map_zone(zone, mapper) do
    for i <- 0..(zone_width(zone) - 1), into: %{} do
      {i,
       for j <- 0..(zone_height(zone[0]) - 1), into: %{} do
         {j, mapper.(zone[i][j])}
       end}
    end
  end

  def zone_height(zone), do: Enum.count(zone)
  def zone_width(zone), do: Enum.count(zone[0])
  def right_border(zone), do: zone_width(zone) - 1
  def bottom_border(zone), do: zone_height(zone) - 1

  def update_safety(tree, forest) do
    %{
      tree
      | left_safe: left_safe?(tree, forest),
        right_safe: right_safe?(tree, forest),
        top_safe: top_safe?(tree, forest),
        bottom_safe: bottom_safe?(tree, forest)
    }
  end

  def update_visibility(tree, forest) do
    %{
      tree
      | visibility_left: visibility_left(tree, forest),
        visibility_right: visibility_right(tree, forest),
        visibility_up: visibility_up(tree, forest),
        visibility_down: visibility_down(tree, forest)
    }
  end

  def update_scenic_score(tree) do
    score = tree.visibility_left * tree.visibility_right * tree.visibility_up * tree.visibility_down
    %{tree | scenic_score: score}
  end

  def count_visible_from([], _tree) do
    0
  end

  def count_visible_from(trees, tree) do
    Enum.reduce_while(trees, 0, fn current_tree, acc ->
      if current_tree.height < tree.height do
        {:cont, acc + 1}
      else
        {:halt, acc + 1}
      end
    end)
  end

  def visibility_left(tree, forest) do
    tree
    |> trees_left(forest)
    |> Enum.reverse()
    |> count_visible_from(tree)
  end

  def visibility_right(tree, forest) do
    tree
    |> trees_right(forest)
    |> count_visible_from(tree)
  end

  def visibility_up(tree, forest) do
    tree
    |> trees_up(forest)
    |> Enum.reverse()
    |> count_visible_from(tree)
  end

  def visibility_down(tree, forest) do
    tree
    |> trees_down(forest)
    |> count_visible_from(tree)
  end

  def left_safe?(tree, forest), do: Enum.any?(trees_left(tree, forest), &covers?(&1, tree))
  def right_safe?(tree, forest), do: Enum.any?(trees_right(tree, forest), &covers?(&1, tree))
  def top_safe?(tree, forest), do: Enum.any?(trees_up(tree, forest), &covers?(&1, tree))
  def bottom_safe?(tree, forest), do: Enum.any?(trees_down(tree, forest), &covers?(&1, tree))

  def trees_up(%{row: 0}, _forest), do: []
  def trees_up(tree, forest), do: for(row <- 0..(tree.row - 1), do: forest[row][tree.col])

  def trees_down(%{row: row}, forest) when row == map_size(forest) - 1, do: []
  def trees_down(tree, forest), do: for(row <- (tree.row + 1)..bottom_border(forest), do: forest[row][tree.col])

  def trees_left(%{col: 0}, _forest), do: []
  def trees_left(tree, forest), do: for(col <- 0..(tree.col - 1), do: forest[tree.row][col])

  def trees_right(%{col: col}, %{0 => row}) when col == map_size(row) - 1, do: []
  def trees_right(tree, forest), do: for(col <- (tree.col + 1)..(zone_width(forest) - 1), do: forest[tree.row][col])

  def covers?(tree1, tree2), do: tree1.height >= tree2.height
  def visible_from?(current_tree, tree), do: current_tree.height <= tree.height

  def visible_from_outside?(tree) do
    Enum.any?([tree.left_safe, tree.right_safe, tree.top_safe, tree.bottom_safe], &(&1 === false))
  end

  def new_tree(height, row, col) do
    %{
      row: row,
      col: col,
      height: height,
      left_safe: nil,
      right_safe: nil,
      top_safe: nil,
      bottom_safe: nil,
      visibility_left: nil,
      visibility_right: nil,
      visibility_up: nil,
      visibility_down: nil,
      scenic_score: nil
    }
  end

  def get_input() do
    __ENV__.file
    |> Path.dirname()
    |> Path.join("..")
    |> Path.expand()
    |> Path.join("input.txt")
    |> File.read!()
  end

  def sanitize_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ""))
    |> Enum.map(fn [_ | lst] -> Enum.map(Enum.slice(lst, 0..-2), &String.to_integer/1) end)
  end
end
