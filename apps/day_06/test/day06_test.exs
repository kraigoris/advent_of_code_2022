defmodule Day06Test do
  use ExUnit.Case
  doctest Day06

  describe "part 1 answer" do
    test "is correct" do
      assert Day06.part1() === 1582
    end
  end

  describe "part 2 answer" do
    test "is correct" do
      assert Day06.part2() === 3588
    end
  end
end
