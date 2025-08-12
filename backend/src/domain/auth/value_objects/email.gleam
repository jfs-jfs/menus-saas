import gleam/dynamic/decode
import gleam/json
import shared/validate

pub type Email {
  Email(value: String)
}

pub type EmailError {
  InvalidFormat(String)
}

pub fn to_json(email: Email) -> json.Json {
  json.string(email.value)
}

pub fn create(maybe_email: String) -> Result(Email, EmailError) {
  case validate.is_email(maybe_email) {
    False -> Error(InvalidFormat("invalid email format: " <> maybe_email))
    True -> Ok(Email(maybe_email))
  }
}

pub fn decoder(maybe_email: String) -> decode.Decoder(Email) {
  case create(maybe_email) {
    Error(InvalidFormat(error)) -> decode.failure(Email(""), error)
    Ok(value) -> decode.success(value)
  }
}
