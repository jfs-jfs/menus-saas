import gleam/string

pub type RationNameError {
  InvalidName(reason: String)
}

pub type RationName {
  RationName(value: String)
}

pub fn create(maybe_description: String) -> Result(RationName, RationNameError) {
  case maybe_description |> string.is_empty() {
    False -> Ok(RationName(maybe_description))
    True -> Error(InvalidName("empty name"))
  }
}
