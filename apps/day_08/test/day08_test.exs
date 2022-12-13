defmodule Day08Test do
  use ExUnit.Case
  doctest Day08

  describe "part 1 answer" do
    test "is correct" do
      assert Day08.part1() === 1849
    end
  end

  describe "part 2 answer" do
    test "is correct" do
      assert Day08.part2() === 201_600
    end
  end
end
