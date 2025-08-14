import gleam/string

pub type DishDescriptionError {
  InvalidDescription(reason: String)
}

pub type DishDescription {
  DishDescription(value: String)
}

pub fn create(
  maybe_description: String,
) -> Result(DishDescription, DishDescriptionError) {
  case maybe_description |> string.is_empty() {
    False -> Ok(DishDescription(maybe_description))
    True -> Error(InvalidDescription("empty name"))
  }
}
