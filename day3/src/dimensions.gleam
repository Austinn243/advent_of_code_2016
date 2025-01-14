//// Contains functionality for working with dimensions of possible triangles.

/// Represents the dimensions of a possible triangle.
pub type Dimensions {
  Dimensions(a: Int, b: Int, c: Int)
}

/// Creates dimensions from a list of integers.
pub fn from_list(list: List(Int)) -> Result(Dimensions, String) {
  case list {
    [a, b, c] -> Ok(Dimensions(a, b, c))
    _ -> Error("Expected a list of 3 integers")
  }
}

/// Determines if a triangle can be formed with the given dimensions.
pub fn is_triangle(dimensions: Dimensions) -> Bool {
  let Dimensions(a, b, c) = dimensions
  a + b > c && a + c > b && b + c > a
}
