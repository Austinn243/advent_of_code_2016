//// Contains functionality for defining and parsing instructions
//// to be executed on a keypad.

import gleam/option.{type Option, None, Some}

/// Represents a single instruction for generating a code
/// from a keypad.
pub type Instruction {
  MoveUp
  MoveDown
  MoveLeft
  MoveRight
}

/// Parse a character into an instruction.
/// If the character is not a valid instruction, return None.
pub fn from_char(char: String) -> Option(Instruction) {
  case char {
    "U" -> Some(MoveUp)
    "D" -> Some(MoveDown)
    "L" -> Some(MoveLeft)
    "R" -> Some(MoveRight)
    _ -> None
  }
}
