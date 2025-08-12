import gleam/dynamic/decode
import gleam/json
import shared/validate

pub type PostalCodeError {
  InvalidFormat(String)
}

pub type PostalCode {
  PostalCode(value: String)
}

pub fn to_json(postal_code: PostalCode) -> json.Json {
  json.string(postal_code.value)
}

pub fn create(maybe_code: String) -> Result(PostalCode, PostalCodeError) {
  case maybe_code |> validate.is_postal_code() {
    False -> Error(InvalidFormat("invalid postal code format"))
    True -> Ok(PostalCode(maybe_code))
  }
}

pub fn decode(maybe_code: String) -> decode.Decoder(PostalCode) {
  case create(maybe_code) {
    Error(InvalidFormat(error)) -> decode.failure(PostalCode(""), error)
    Ok(value) -> decode.success(value)
  }
}
