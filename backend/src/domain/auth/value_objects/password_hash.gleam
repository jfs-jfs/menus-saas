import gleam/dynamic/decode
import ports/services/hasher_service.{type HasherService}
import shared/validate

pub type PasswordHash {
  PasswordHash(value: String)
}

pub fn create(maybe_hash: String) -> Result(PasswordHash, String) {
  case validate.is_sha256_hash(maybe_hash) {
    False -> Error("Invalid PasswordHash")
    True -> Ok(PasswordHash(maybe_hash))
  }
}

pub fn decoder(
  password_unhashed: String,
  hasher_service: HasherService,
) -> decode.Decoder(PasswordHash) {
  let hash = hasher_service.hash(password_unhashed)
  case create(hash) {
    Error(err) -> decode.failure(PasswordHash(""), err)
    Ok(value) -> decode.success(value)
  }
}
