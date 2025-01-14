//// Advent of Code 2016, Day 1
//// No Time for a Taxicab
//// https://adventofcode.com/2016/day/1

import gleam/io
import gleam/list
import gleam/option
import gleam/regex
import simplifile
import instruction.{type Instruction}
import position
import simulation

const input_file_path: String = "input.txt"

/// Reads a list of instructions from a file.
pub fn read_instructions(file_path: String) -> List(Instruction) {
  let instruction_regex = case regex.from_string("(R|L|\\d+)") {
    Ok(regex) -> regex
    Error(msg) -> panic(msg)
  }

  case simplifile.read(file_path) {
    Ok(contents) ->
      contents
      |> regex.scan(with: instruction_regex)
      |> list.map(fn(match) { match.content })
      |> list.map(instruction.from_string)
      |> option.values
    Error(msg) -> panic(msg)
  }
}

/// Execute the program.
pub fn main() -> Nil {
  let instructions = read_instructions(input_file_path)
  let simulation = simulation.create()

  let final_position = simulation.find_final_position(simulation, instructions)
  io.debug(position.distance(final_position))

  let easter_bunny_hq_position =
    simulation.find_first_repeated_position(simulation, instructions)

  io.debug(position.distance(easter_bunny_hq_position))

  Nil
}
