import gleam/string

pub type DishNameError {
  InvalidName(reason: String)
}

pub type DishName {
  DishName(value: String)
}

pub fn create(maybe_description: String) -> Result(DishName, DishNameError) {
  case maybe_description |> string.is_empty() {
    False -> Ok(DishName(maybe_description))
    True -> Error(InvalidName("empty name"))
  }
}
