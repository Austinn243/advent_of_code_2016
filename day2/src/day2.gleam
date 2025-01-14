//// Advent of Code 2016, Day 2
//// Bathroom Security
//// https://adventofcode.com/2016/day/2

import gleam/io
import gleam/list
import gleam/option
import gleam/string
import simplifile
import instruction.{type Instruction}
import keypad

const input_file_path: String = "input.txt"

/// Reads sequences of instructions from a file.
pub fn read_instructions(file_path: String) -> List(List(Instruction)) {
  let lines = case simplifile.read(file_path) {
    Ok(contents) ->
      contents
      |> string.trim
      |> string.split("\n")
    Error(msg) -> panic(msg)
  }

  let instructions =
    lines
    |> list.map(string.to_graphemes)
    |> list.map(list.map(_, instruction.from_char))
    |> list.map(option.values)

  instructions
}

/// Executes the program.
pub fn main() {
  let instructions = read_instructions(input_file_path)

  let basic_keypad = keypad.create_basic_layout()
  let basic_code = keypad.find_code(basic_keypad, instructions)
  io.println("The code for the basic keypad is: " <> basic_code)

  let diamond_keypad = keypad.create_diamond_layout()
  let diamond_code = keypad.find_code(diamond_keypad, instructions)
  io.println("The code for the diamond keypad is: " <> diamond_code)
}
