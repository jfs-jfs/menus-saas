import gleam/string

pub type MenuNameError {
  InvalidName(reason: String)
}

pub type MenuName {
  MenuName(value: String)
}

pub fn create(maybe_name: String) -> Result(MenuName, MenuNameError) {
  case maybe_name |> string.is_empty() {
    False -> Ok(MenuName(maybe_name))
    True -> Error(InvalidName("empty name"))
  }
}
