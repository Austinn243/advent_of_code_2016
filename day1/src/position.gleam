//// Contains functions for working with positions on a grid.

import gleam/int

/// Represents the starting position on a grid.
pub const origin = Position(0, 0)

/// Represents a two-dimensional position on a grid.
pub type Position {
  Position(x: Int, y: Int)
}

/// Add two positions together.
pub fn add(position1: Position, position2: Position) -> Position {
  Position(x: position1.x + position2.x, y: position1.y + position2.y)
}

/// Calculate the distance between the current position and the origin.
pub fn distance(position: Position) -> Int {
  let x = int.absolute_value(position.x)
  let y = int.absolute_value(position.y)
  x + y
}
