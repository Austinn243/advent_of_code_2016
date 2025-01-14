//// Contains functionality for creating and interacting with keypads.

import gleam/dict.{type Dict}
import gleam/list
import gleam/string
import instruction.{type Instruction, MoveDown, MoveLeft, MoveRight, MoveUp}

/// Represents a position on the keypad.
pub type Position {
  Position(x: Int, y: Int)
}

/// Represents a keypad with keys at various positions.
pub type Keypad {
  Keypad(keys: Dict(Position, String), current_position: Position)
}

/// Creates a new keypad with the given starting position.
pub fn new(starting_position: Position) -> Keypad {
  Keypad(keys: dict.new(), current_position: starting_position)
}

/// Adds a key to the keypad at the given position.
pub fn add_key(keypad: Keypad, position: Position, key: String) -> Keypad {
  let updated_keypad = dict.insert(keypad.keys, position, key)
  Keypad(..keypad, keys: updated_keypad)
}

/// Retrieves the key at the current position of the keypad.
pub fn current_key(keypad: Keypad) -> String {
  case dict.get(keypad.keys, keypad.current_position) {
    Ok(key) -> key
    Error(Nil) -> panic as "No key at current position"
  }
}

/// Executes the given instruction on the keypad.
pub fn execute(keypad: Keypad, instruction: Instruction) -> Keypad {
  let current_x = keypad.current_position.x
  let current_y = keypad.current_position.y
  let new_position = case instruction {
    MoveUp -> Position(current_x, current_y - 1)
    MoveDown -> Position(current_x, current_y + 1)
    MoveLeft -> Position(current_x - 1, current_y)
    MoveRight -> Position(current_x + 1, current_y)
  }
  case dict.has_key(keypad.keys, new_position) {
    True -> Keypad(..keypad, current_position: new_position)
    False -> keypad
  }
}

/// Finds the key that is pressed after executing the given sequence of instructions.
pub fn find_key(keypad: Keypad, sequence: List(Instruction)) -> String {
  let updated_keypad = list.fold(sequence, keypad, execute)
  current_key(updated_keypad)
}

/// Finds the code that is entered after executing the given sequences of instructions.
pub fn find_code(
  keypad: Keypad,
  instructions: List(List(Instruction)),
) -> String {
  let keys = list.map(instructions, find_key(keypad, _))
  string.join(keys, "")
}

/// Creates a basic layout for a keypad.
pub fn create_basic_layout() -> Keypad {
  let keypad =
    new(Position(1, 1))
    |> add_key(Position(0, 0), "1")
    |> add_key(Position(1, 0), "2")
    |> add_key(Position(2, 0), "3")
    |> add_key(Position(0, 1), "4")
    |> add_key(Position(1, 1), "5")
    |> add_key(Position(2, 1), "6")
    |> add_key(Position(0, 2), "7")
    |> add_key(Position(1, 2), "8")
    |> add_key(Position(2, 2), "9")
  keypad
}

/// Creates a diamond layout for a keypad.
pub fn create_diamond_layout() -> Keypad {
  let keypad =
    new(Position(2, 2))
    |> add_key(Position(2, 0), "1")
    |> add_key(Position(1, 1), "2")
    |> add_key(Position(2, 1), "3")
    |> add_key(Position(3, 1), "4")
    |> add_key(Position(0, 2), "5")
    |> add_key(Position(1, 2), "6")
    |> add_key(Position(2, 2), "7")
    |> add_key(Position(3, 2), "8")
    |> add_key(Position(4, 2), "9")
    |> add_key(Position(1, 3), "A")
    |> add_key(Position(2, 3), "B")
    |> add_key(Position(3, 3), "C")
    |> add_key(Position(2, 4), "D")
  keypad
}
