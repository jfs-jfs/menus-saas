import gleam/dynamic/decode
import gleam/json
import gleam/string

pub type RecipientNameError {
  InvalidName(message: String)
}

pub type RecipientName {
  RecipientName(value: String)
}

pub fn to_json(recipient_name: RecipientName) -> json.Json {
  json.string(recipient_name.value)
}

pub fn create(maybe_name: String) -> Result(RecipientName, RecipientNameError) {
  case string.is_empty(maybe_name) {
    False -> Ok(RecipientName(maybe_name))
    True -> Error(InvalidName("invalid recipient name"))
  }
}

pub fn decode(maybe_name: String) -> decode.Decoder(RecipientName) {
  case create(maybe_name) {
    Error(InvalidName(message)) -> decode.failure(RecipientName(""), message)
    Ok(value) -> decode.success(value)
  }
}
