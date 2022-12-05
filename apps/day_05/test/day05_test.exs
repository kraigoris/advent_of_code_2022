defmodule Day05Test do
  use ExUnit.Case
  doctest Day05

  describe "part 1 answer" do
    test "is correct" do
      assert Day05.part1() === "VPCDMSLWJ"
    end
  end

  describe "part 2 answer" do
    test "is correct" do
      assert Day05.part2() === "TPWCGNCCG"
    end
  end
end
