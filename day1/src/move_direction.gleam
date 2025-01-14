//// Contains functionality for defining and manipulating directions in which
//// our simulated character can move.

import position.{type Position, Position}

/// Represents a direction in which the character can move.
pub type MoveDirection {
  North
  East
  South
  West
}

/// Create a position describing an offset in a given direction.
pub fn offset(move_direction: MoveDirection, steps: Int) -> Position {
  case move_direction {
    North -> Position(0, steps)
    East -> Position(steps, 0)
    South -> Position(0, -steps)
    West -> Position(-steps, 0)
  }
}

/// Change a direction by turning it to the left.
pub fn turn_left(move_direction: MoveDirection) -> MoveDirection {
  case move_direction {
    North -> West
    East -> North
    South -> East
    West -> South
  }
}

/// Change a direction by turning it to the right.
pub fn turn_right(move_direction: MoveDirection) -> MoveDirection {
  case move_direction {
    North -> East
    East -> South
    South -> West
    West -> North
  }
}
