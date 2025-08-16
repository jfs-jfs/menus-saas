import gleam/dynamic/decode
import gleam/json
import shared/validate

pub type RecipientEmail {
  RecipientEmail(value: String)
}

pub type RecipientEmailError {
  InvalidFormat(String)
}

pub fn to_json(recipient_email: RecipientEmail) -> json.Json {
  json.string(recipient_email.value)
}

pub fn create(
  maybe_email: String,
) -> Result(RecipientEmail, RecipientEmailError) {
  case validate.is_email(maybe_email) {
    False -> Error(InvalidFormat("invalid email format"))
    True -> Ok(RecipientEmail(maybe_email))
  }
}

pub fn decode(maybe_email: String) -> decode.Decoder(RecipientEmail) {
  case create(maybe_email) {
    Error(InvalidFormat(error)) -> decode.failure(RecipientEmail(""), error)
    Ok(value) -> decode.success(value)
  }
}
