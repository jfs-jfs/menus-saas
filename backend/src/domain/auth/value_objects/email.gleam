import gleam/dynamic/decode
import shared/validate

pub type Email {
  Email(value: String)
}

pub fn create(maybe_email) -> Result(Email, String) {
  case validate.is_email(maybe_email) {
    False -> Error("Invalid Email")
    True -> Ok(Email(maybe_email))
  }
}

pub fn decoder(maybe_email) -> decode.Decoder(Email) {
  case create(maybe_email) {
    Error(error) -> decode.failure(Email(""), error)
    Ok(value) -> decode.success(value)
  }
}
