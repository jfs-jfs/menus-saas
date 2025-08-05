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
