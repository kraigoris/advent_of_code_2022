defmodule Day03Test do
  use ExUnit.Case
  doctest Day03

  describe "part 1 answer" do
    test "is correct" do
      assert Day03.part1() === 8139
    end
  end

  describe "part 2 answer" do
    test "is correct" do
      assert Day03.part2() === 2668
    end
  end
end
