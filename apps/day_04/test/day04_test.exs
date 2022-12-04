defmodule Day04Test do
  use ExUnit.Case
  doctest Day04

  describe "part 1 answer" do
    test "is correct" do
      assert Day04.part1() === 540
    end
  end

  describe "part 2 answer" do
    test "is correct" do
      assert Day04.part2() === 872
    end
  end
end
