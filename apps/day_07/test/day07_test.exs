defmodule Day07Test do
  use ExUnit.Case
  doctest Day07

  describe "part 1 answer" do
    test "is correct" do
      assert Day07.part1() === 1_555_642
    end
  end

  describe "part 2 answer" do
    test "is correct" do
      assert Day07.part2() === 5_974_547
    end
  end
end
