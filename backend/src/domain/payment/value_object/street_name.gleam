import gleam/bool
import gleam/dynamic/decode
import gleam/json
import gleam/string

pub type StreetNameError {
  InvalidFormat(String)
}

pub type StreetName {
  StreetName(value: String)
}

pub fn to_json(street_name: StreetName) -> json.Json {
  json.string(street_name.value)
}

pub fn create(maybe_street: String) -> Result(StreetName, StreetNameError) {
  case maybe_street |> string.is_empty() |> bool.negate() {
    False -> Error(InvalidFormat("invalid street format"))
    True -> Ok(StreetName(maybe_street))
  }
}

pub fn decode(maybe_street: String) -> decode.Decoder(StreetName) {
  case create(maybe_street) {
    Error(InvalidFormat(error)) -> decode.failure(StreetName(""), error)
    Ok(value) -> decode.success(value)
  }
}
