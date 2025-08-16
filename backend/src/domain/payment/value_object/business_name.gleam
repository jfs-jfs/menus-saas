import gleam/bool
import gleam/dynamic/decode
import gleam/json
import gleam/string

pub type BusinessNameError {
  InvalidName(String)
}

pub type BusinessName {
  BusinessName(value: String)
}

pub fn to_json(business_name: BusinessName) -> json.Json {
  let BusinessName(value:) = business_name
  json.string(value)
}

pub fn create(maybe_name: String) -> Result(BusinessName, BusinessNameError) {
  case maybe_name |> string.is_empty() |> bool.negate() {
    False -> Error(InvalidName("invalid business name format"))
    True -> Ok(BusinessName(maybe_name))
  }
}

pub fn decoder(maybe_name: String) -> decode.Decoder(BusinessName) {
  case create(maybe_name) {
    Error(InvalidName(error)) -> decode.failure(BusinessName(""), error)
    Ok(value) -> decode.success(value)
  }
}
