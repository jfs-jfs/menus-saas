import domain/auth/value_objects/email.{type Email}
import domain/auth/value_objects/password_hash.{type PasswordHash}
import gleam/dynamic/decode.{type Decoder}
import ports/services/hasher_service.{type HasherService}

pub fn decoder(hasher_service: HasherService) -> Decoder(#(Email, PasswordHash)) {
  use email_raw <- decode.field("email", decode.string)
  use password_raw <- decode.field("password", decode.string)
  use password <- decode.then(password_hash.decoder(
    password_raw,
    hasher_service,
  ))
  use email <- decode.then(email.decoder(email_raw))

  decode.success(#(email, password))
}
