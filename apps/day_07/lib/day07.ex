defmodule Day07 do
  def part1() do
    get_input()
    |> parse_command_outputs()
    |> create_file_cache()
    |> then(fn cache ->
      Enum.map(cache, fn {path, contents} ->
        contents
        |> Enum.map(&%{&1 | size: get_size(Path.join(path, &1.name), &1, cache)})
        |> then(fn contents -> {path, contents} end)
      end)
    end)
    |> Enum.map(fn {path, contents} -> {path, contents |> Enum.map(& &1.size) |> Enum.sum()} end)
    |> Enum.filter(fn {_path, size} -> size < 100_000 end)
    |> Enum.map(fn {_, size} -> size end)
    |> Enum.sum()
  end

  def get_size(item_path, %{type: :tree}, cache) do
    contents = Map.get(cache, item_path)

    Enum.reduce(contents, 0, fn item, acc ->
      acc + get_size(Path.join(item_path, item.name), item, cache)
    end)
  end

  def get_size(_item_path, %{type: :file, size: size}, _cache) do
    size
  end

  def create_file_cache(command_outputs) do
    Enum.reduce(command_outputs, %{path: "/", cache: %{}}, fn command, acc ->
      case command do
        %{program: "cd", args: [path]} ->
          %{acc | path: Path.expand(Path.join(acc.path, path))}

        %{program: "ls", output: output} ->
          %{acc | cache: Map.put(acc.cache, acc.path, parse_ls_output(output))}
      end
    end).cache
  end

  def parse_ls_output(output_lines) do
    Enum.map(output_lines, fn line ->
      case String.split(line, " ") do
        ["dir", name] -> %{type: :tree, name: name, size: nil}
        [size, name] -> %{type: :file, name: name, size: String.to_integer(size)}
      end
    end)
  end

  def parse_command_outputs(input_str) do
    input_str
    |> String.trim()
    |> String.split("$")
    |> Enum.filter(&(&1 !== ""))
    |> Enum.map(&parse_command_with_output(&1))
  end

  def parse_command_with_output(command_with_output_str) do
    command_with_output_str
    |> String.trim()
    |> String.split("\n")
    |> then(fn [command | output] ->
      [name | args] = String.split(command, " ")

      %{
        command: command,
        program: name,
        args: args,
        output: output
      }
    end)
  end

  def get_input() do
    __ENV__.file
    |> Path.dirname()
    |> Path.join("..")
    |> Path.expand()
    |> Path.join("input.txt")
    |> File.read!()
  end
end
