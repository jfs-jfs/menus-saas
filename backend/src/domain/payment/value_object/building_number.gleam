import gleam/bool
import gleam/dynamic/decode
import gleam/json
import gleam/string

pub type BuildingNumberError {
  InvalidFormat(String)
}

pub type BuildingNumber {
  BuildingNumber(value: String)
}

pub fn to_json(building_number: BuildingNumber) -> json.Json {
  json.string(building_number.value)
}

pub fn create(
  maybe_number: String,
) -> Result(BuildingNumber, BuildingNumberError) {
  case maybe_number |> string.is_empty() |> bool.negate() {
    False -> Error(InvalidFormat("invalid building number format"))
    True -> Ok(BuildingNumber(maybe_number))
  }
}

pub fn decoder(maybe_number: String) -> decode.Decoder(BuildingNumber) {
  case create(maybe_number) {
    Error(InvalidFormat(error)) -> decode.failure(BuildingNumber(""), error)
    Ok(value) -> decode.success(value)
  }
}
