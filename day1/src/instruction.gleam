//// Defines instructions that can be executed on our simulation.

import gleam/int
import gleam/option.{type Option, None, Some}

/// Represents an instruction.
pub type Instruction {
  MoveForward(steps: Int)
  TurnLeft
  TurnRight
}

/// Parses a raw instruction string into an Instruction.
/// Returns None if the instruction is invalid.
pub fn from_string(raw_instruction: String) -> Option(Instruction) {
  case raw_instruction {
    "L" -> Some(TurnLeft)
    "R" -> Some(TurnRight)
    _ -> {
      case int.parse(raw_instruction) {
        Ok(steps) -> Some(MoveForward(steps))
        Error(Nil) -> None
      }
    }
  }
}
