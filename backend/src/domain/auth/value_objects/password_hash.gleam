import gleam/dynamic/decode
import ports/services/hasher_service.{type HasherService}
import shared/validate

pub type PasswordError {
  InvalidHashFormat(String)
  InvalidPasswordFormat(String)
}

pub type PasswordHash {
  PasswordHash(value: String)
}

pub fn create(maybe_hash: String) -> Result(PasswordHash, PasswordError) {
  case validate.is_sha256_hash(maybe_hash) {
    False -> Error(InvalidHashFormat("invalid hash format"))
    True -> Ok(PasswordHash(maybe_hash))
  }
}

pub fn is_equal(this: PasswordHash, to: PasswordHash) -> Bool {
  this.value == to.value
}

pub fn from_plaintext(
  plaintext: String,
  hasher_service: HasherService,
) -> Result(PasswordHash, PasswordError) {
  case validate.is_password(plaintext) {
    False -> Error(InvalidPasswordFormat("invalid password format"))
    True -> create(plaintext |> hasher_service.hash())
  }
}

pub fn decoder(
  password_raw: String,
  hasher_service: HasherService,
) -> decode.Decoder(PasswordHash) {
  case from_plaintext(password_raw, hasher_service) {
    Ok(value) -> decode.success(value)
    Error(InvalidHashFormat(err)) | Error(InvalidPasswordFormat(err)) ->
      decode.failure(PasswordHash(""), err)
  }
}
