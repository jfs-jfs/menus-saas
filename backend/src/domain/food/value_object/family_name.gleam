import gleam/string

pub type FamilyNameError {
  InvalidName(reason: String)
}

pub type FamilyName {
  FamilyName(value: String)
}

pub fn create(maybe_description: String) -> Result(FamilyName, FamilyNameError) {
  case maybe_description |> string.is_empty() {
    False -> Ok(FamilyName(maybe_description))
    True -> Error(InvalidName("empty name"))
  }
}
