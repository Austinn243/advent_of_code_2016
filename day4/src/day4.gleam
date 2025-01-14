//// Advent of Code 2016. Day 4
//// Security Through Obscurity
//// https://adventofcode.com/2016/day/4

import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/regex
import gleam/result
import gleam/string
import simplifile

const input_file: String = "input.txt"

const room_pattern: String = "([a-z\\-]+)\\-(\\d+)\\[([a-z]{5})\\]"

/// Represents a possible room in the building.
pub type RoomInfo {
  RoomInfo(encrypted_name: String, sector_id: Int, checksum: String)
}

/// Parse room information from a string.
pub fn parse_room(line: String) -> Result(RoomInfo, String) {
  let assert Ok(room_regex) = regex.from_string(room_pattern)

  let matches = regex.scan(with: room_regex, content: line)

  case matches {
    [match] -> {
      case match.submatches {
        [Some(encrypted_name), Some(sector_id), Some(checksum)] -> {
          case int.parse(sector_id) {
            Ok(s) -> Ok(RoomInfo(encrypted_name, s, checksum))
            Error(_) -> Error("Invalid sector id")
          }
        }
        _ -> Error("Invalid room info")
      }
    }
    _ -> Error("Invalid room info")
  }
}

/// Determine if a room is real.
pub fn is_room_real(room: RoomInfo) -> Bool {
  let five_most_common_chars = five_most_common_chars(room.encrypted_name)

  let calculated_checksum =
    five_most_common_chars
    |> string.concat

  calculated_checksum == room.checksum
}

/// Find the five most common characters in an encrypted name.
fn five_most_common_chars(encrypted_name: String) -> List(String) {
  todo
}

/// Read information about possible rooms from a file.
pub fn read_rooms_info(input_path: String) -> List(RoomInfo) {
  let read_result = simplifile.read(input_path)

  case read_result {
    Ok(contents) -> {
      let lines =
        contents
        |> string.trim
        |> string.split("\n")

      let rooms =
        lines
        |> list.map(parse_room)
        |> result.values

      rooms
    }
    Error(_) -> []
  }
}

/// Execute the program.
pub fn main() {
  let rooms = read_rooms_info(input_file)

  rooms
  |> list.each(io.debug)

  let real_rooms = list.filter(rooms, is_room_real)
  let sum_of_sector_ids =
    real_rooms
    |> list.map(fn(room) { room.sector_id })
    |> list.fold(0, fn(a, b) { a + b })

  io.println(
    "Sum of sector IDs of real rooms: " <> int.to_string(sum_of_sector_ids),
  )
}
