//// Contains the logic for simulating the movement along a city block grid.

import gleam/list
import gleam/set.{type Set}
import instruction.{type Instruction, MoveForward, TurnLeft, TurnRight}
import move_direction.{type MoveDirection, North}
import position.{type Position, Position}

/// Simulates the movement along a city block grid.
pub type Simulation {
  Simulation(move_direction: MoveDirection, position: Position)
}

/// Create a new simulation.
pub fn create() -> Simulation {
  Simulation(North, position.origin)
}

/// Turn the simulated character to the left.
fn turn_left(simulation: Simulation) -> Simulation {
  let new_direction = move_direction.turn_left(simulation.move_direction)
  Simulation(new_direction, simulation.position)
}

/// Turn the simulated character to the right.
fn turn_right(simulation: Simulation) -> Simulation {
  let new_direction = move_direction.turn_right(simulation.move_direction)
  Simulation(new_direction, simulation.position)
}

/// Helper function to determine the final position after executing a single
/// instruction.
fn find_final_position_helper(
  simulation: Simulation,
  instruction: Instruction,
) -> Simulation {
  case instruction {
    TurnLeft -> turn_left(simulation)
    TurnRight -> turn_right(simulation)
    MoveForward(steps) -> {
      let move_offset = move_direction.offset(simulation.move_direction, steps)
      let new_position = position.add(simulation.position, move_offset)

      Simulation(simulation.move_direction, new_position)
    }
  }
}

/// Determine the final position after executing a list of instructions.
pub fn find_final_position(
  simulation: Simulation,
  instructions: List(Instruction),
) -> Position {
  let final_state =
    list.fold(instructions, simulation, find_final_position_helper)
  final_state.position
}

/// Helper function to determine the first position that is visited twice.
fn find_first_repeated_position_helper(
  simulation: Simulation,
  instructions: List(Instruction),
  visited_positions: Set(Position),
) -> Simulation {
  case instructions {
    [] -> simulation
    [instruction, ..rest] -> {
      case instruction {
        TurnLeft ->
          find_first_repeated_position_helper(
            turn_left(simulation),
            rest,
            visited_positions,
          )
        TurnRight ->
          find_first_repeated_position_helper(
            turn_right(simulation),
            rest,
            visited_positions,
          )
        MoveForward(steps) -> {
          let move_offset = move_direction.offset(simulation.move_direction, 1)
          let new_position = position.add(simulation.position, move_offset)
          let updated_simulation =
            Simulation(simulation.move_direction, new_position)

          case set.contains(visited_positions, new_position) {
            True -> updated_simulation
            False -> {
              let new_visited_positions =
                set.insert(visited_positions, new_position)

              let next_instructions = case steps > 1 {
                True -> [MoveForward(steps - 1), ..rest]
                False -> rest
              }

              find_first_repeated_position_helper(
                updated_simulation,
                next_instructions,
                new_visited_positions,
              )
            }
          }
        }
      }
    }
  }
}

/// Determine the first position that is visited twice after executing
/// a list of instructions.
pub fn find_first_repeated_position(
  simulation: Simulation,
  instructions: List(Instruction),
) -> Position {
  let visited_positions = set.new()
  let final_simulation =
    find_first_repeated_position_helper(
      simulation,
      instructions,
      visited_positions,
    )

  let final_position = final_simulation.position
  final_position
}
