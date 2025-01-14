//// Advent of Code 2016, Day 3
//// Squares With Three Sides
//// https://adventofcode.com/2016/day/3

import gleam/int
import gleam/io
import gleam/list
import gleam/regex
import gleam/result
import gleam/string
import simplifile.{type FileError}
import dimensions.{type Dimensions, Dimensions}

const input_file_path: String = "input.txt"

/// Parse a line of raw input as a set of dimensions.
fn parse_dimensions(line: String) -> Result(Dimensions, String) {
  let assert Ok(pattern) = regex.from_string("\\s+")

  let parts =
    line
    |> string.trim
    |> regex.split(with: pattern)

  case list.length(parts) {
    3 -> {
      let dimensions = list.map(parts, int.parse)
      case dimensions {
        [Ok(a), Ok(b), Ok(c)] -> Ok(Dimensions(a, b, c))
        _ -> Error("Invalid dimensions")
      }
    }
    _ -> Error("Invalid number of dimensions")
  }
}

/// Parse a collection of possible triangle dimensions from an input string by row.
pub fn parse_dimensions_by_row(raw_input: String) -> List(Dimensions) {
  raw_input
  |> string.split("\n")
  |> list.map(parse_dimensions)
  |> result.values
}

/// Parse a collection of possible triangle dimensions from an input string by column.
pub fn parse_dimensions_by_column(raw_input: String) -> List(Dimensions) {
  let assert Ok(pattern) = regex.from_string("\\s+")

  let values =
    raw_input
    |> regex.split(with: pattern)
    |> list.map(int.parse)
    |> result.values

  let values_by_column =
    values
    |> list.sized_chunk(3)
    |> list.transpose

  let dimensions =
    values_by_column
    |> list.flatten
    |> list.sized_chunk(3)
    |> list.map(dimensions.from_list)
    |> result.values

  dimensions
}

/// Read the contents of an input file.
pub fn read_input(file_path: String) -> Result(String, FileError) {
  simplifile.read(file_path)
  |> result.map(string.trim)
}

/// Executes the program.
pub fn main() {
  let assert Ok(raw_input) = read_input(input_file_path)

  {
    let dimensions = parse_dimensions_by_row(raw_input)
    let possible_triangles = list.filter(dimensions, dimensions.is_triangle)
    let count = list.length(possible_triangles)

    let message =
      "The number of possible triangles when grouping by row is: "
      <> int.to_string(count)

    io.println(message)
  }

  {
    let dimensions = parse_dimensions_by_column(raw_input)
    let possible_triangles = list.filter(dimensions, dimensions.is_triangle)
    let count = list.length(possible_triangles)

    let message =
      "The number of possible triangles when grouping by column is: "
      <> int.to_string(count)

    io.println(message)
  }
}
