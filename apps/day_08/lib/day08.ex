defmodule Day08 do
  def part1() do
    get_input()
    |> sanitize_input()
    |> parse_zone()
    |> Enum.map(fn {_i, row} ->
      Enum.count(Enum.filter(row, fn {_j, cell} -> visible_from_outside?(cell) end))
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

    # |> then(fn forest -> map_zone(forest, &update_visibility(&1, forest)) end)
    # |> then(fn forest -> map_zone(forest, &update_scenic_score(&1)) end)
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
      | visibility_left: trees_left(tree, forest) |> Enum.count_until(&covers?(&1, tree), zone_width(forest)),
        visibility_right: trees_right(tree, forest) |> Enum.count_until(&covers?(&1, tree), zone_width(forest)),
        visibility_up: trees_up(tree, forest) |> Enum.count_until(&covers?(&1, tree), zone_height(forest)),
        visibility_down: trees_down(tree, forest) |> Enum.count_until(&covers?(&1, tree), zone_height(forest))
    }
  end

  def update_scenic_score(tree) do
    params = [tree.visibility_left, tree.visibility_right, tree.visibility_up, tree.visibility_down]
    Enum.reduce(params, 1, fn value, acc -> value * acc end)
  end

  def left_safe?(tree, forest) do
    tree.col !== 0 && Enum.any?(trees_left(tree, forest), &covers?(&1, tree))
  end

  def right_safe?(tree, forest) do
    tree.col !== zone_width(forest) - 1 && Enum.any?(trees_right(tree, forest), &covers?(&1, tree))
  end

  def top_safe?(tree, forest) do
    tree.row !== 0 && Enum.any?(trees_up(tree, forest), &covers?(&1, tree))
  end

  def bottom_safe?(tree, forest) do
    tree.row !== zone_height(forest) - 1 && Enum.any?(trees_down(tree, forest), &covers?(&1, tree))
  end

  def trees_up(tree, forest) do
    for row <- 0..(tree.row - 1), do: forest[row][tree.col]
  end

  def trees_down(tree, forest) do
    for row <- (tree.row + 1)..bottom_border(forest), do: forest[row][tree.col]
  end

  def trees_left(tree, forest) do
    for col <- 0..(tree.col - 1), do: forest[tree.row][col]
  end

  def trees_right(tree, forest) do
    for col <- (tree.col + 1)..(zone_width(forest) - 1), do: forest[tree.row][col]
  end

  def visible_from_outside?(cell) do
    Enum.any?([cell.left_safe, cell.right_safe, cell.top_safe, cell.bottom_safe], &(&1 === false))
  end

  def covers?(tree1, tree2) do
    tree1.height >= tree2.height
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
