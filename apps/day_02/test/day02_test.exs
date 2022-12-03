defmodule Day02Test do
  use ExUnit.Case
  doctest Day02

  describe "play_round_with_guide/2" do
    test "Rock (A) loses to Paper (Y) with result of 8" do
      assert Day02.play_round_with_guide("A", "Y") === 8
    end

    test "Paper (B) loses to Rock (X) with result of 1" do
      assert Day02.play_round_with_guide("B", "X") === 1
    end

    test "Scissors (B) vs Scissors (Z) results in draw with the score of 6" do
      assert Day02.play_round_with_guide("C", "Z") === 6
    end
  end

  describe "answer to part 1" do
    test "is correct" do
      assert Day02.part1() === 12679
    end
  end

  describe "answer to part 2" do
    test "is correct" do
      assert Day02.part2() === 14470
    end
  end
end
