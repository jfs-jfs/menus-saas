import gleam/string

pub type CartaNameError {
  InvalidName(reason: String)
}

pub type CartaName {
  CartaName(value: String)
}

pub fn create(maybe_name: String) -> Result(CartaName, CartaNameError) {
  case maybe_name |> string.is_empty() {
    False -> Ok(CartaName(maybe_name))
    True -> Error(InvalidName("empty name"))
  }
}
