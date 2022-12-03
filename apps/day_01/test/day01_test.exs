defmodule Day01Test do
  use ExUnit.Case
  doctest Day01

  describe "answer to part 1" do
    test "is correct" do
      assert Day01.part1() === 72602
    end
  end

  describe "answer to part 2" do
    test "is correct" do
      assert Day01.part2() === 207_410
    end
  end
end
