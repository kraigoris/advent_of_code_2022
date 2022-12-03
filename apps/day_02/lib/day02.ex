defmodule Day02 do
  def part1() do
    get_strategy_guide()
    |> Enum.map(fn [op, me] -> play_round_with_guide(op, me) end)
    |> Enum.sum()
  end

  def part2() do
    get_strategy_guide()
    |> Enum.map(fn [op, me] -> play_round_with_updated_guide(op, me) end)
    |> Enum.sum()
  end

  def get_strategy_guide() do
    get_input()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
  end

  def get_input() do
    __ENV__.file
    |> Path.dirname()
    |> Path.join("..")
    |> Path.expand()
    |> Path.join("input.txt")
    |> File.read!()
  end

  def shape_name("A"), do: :rock
  def shape_name("X"), do: :rock
  def shape_name("B"), do: :paper
  def shape_name("Y"), do: :paper
  def shape_name("C"), do: :scissors
  def shape_name("Z"), do: :scissors

  def solution_name("X"), do: :lose
  def solution_name("Y"), do: :draw
  def solution_name("Z"), do: :win

  def shape_value(:rock), do: 1
  def shape_value(:paper), do: 2
  def shape_value(:scissors), do: 3

  def play(:rock, :paper), do: :win
  def play(:rock, :scissors), do: :lose
  def play(:rock, :rock), do: :draw
  def play(:paper, :rock), do: :lose
  def play(:paper, :scissors), do: :win
  def play(:paper, :paper), do: :draw
  def play(:scissors, :rock), do: :win
  def play(:scissors, :paper), do: :lose
  def play(:scissors, :scissors), do: :draw

  def solve(:rock, :win), do: :paper
  def solve(:rock, :draw), do: :rock
  def solve(:rock, :lose), do: :scissors
  def solve(:paper, :win), do: :scissors
  def solve(:paper, :draw), do: :paper
  def solve(:paper, :lose), do: :rock
  def solve(:scissors, :win), do: :rock
  def solve(:scissors, :draw), do: :scissors
  def solve(:scissors, :lose), do: :paper

  def play_result_value(:win), do: 6
  def play_result_value(:draw), do: 3
  def play_result_value(:lose), do: 0

  def round_result(result, shape), do: play_result_value(result) + shape_value(shape)

  def play_round(opponent_shape, my_shape) do
    result = play(opponent_shape, my_shape)
    round_result(result, my_shape)
  end

  def play_round_with_guide(opponent_shape_encrypted, my_shape_encrypted) do
    opponent_shape = shape_name(opponent_shape_encrypted)
    my_shape = shape_name(my_shape_encrypted)
    play_round(opponent_shape, my_shape)
  end

  def play_round_with_updated_guide(opponent_shape_encrypted, result_encrypted) do
    opponent_shape = shape_name(opponent_shape_encrypted)
    desired_result = solution_name(result_encrypted)
    solution_shape = solve(opponent_shape, desired_result)
    round_result(desired_result, solution_shape)
  end
end
