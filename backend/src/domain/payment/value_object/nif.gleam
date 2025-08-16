import gleam/dynamic/decode
import gleam/json
import shared/validate

pub type NIFError {
  InvalidNIF(String)
}

pub type NIF {
  NIF(value: String)
}

pub fn to_json(nif: NIF) -> json.Json {
  json.string(nif.value)
}

pub fn create(maybe_nif: String) -> Result(NIF, NIFError) {
  case maybe_nif |> validate.is_nif() {
    False -> Error(InvalidNIF("invalid NIF format"))
    True -> Ok(NIF(maybe_nif))
  }
}

pub fn decoder(maybe_nif: String) -> decode.Decoder(NIF) {
  case create(maybe_nif) {
    Error(InvalidNIF(error)) -> decode.failure(NIF(""), error)
    Ok(value) -> decode.success(value)
  }
}
