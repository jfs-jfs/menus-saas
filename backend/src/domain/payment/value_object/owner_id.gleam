import gleam/dynamic/decode
import shared/validate

pub type OwnerIdError {
  InvalidId(String)
}

pub type OwnerId {
  OwnerId(value: Int)
}

pub fn create(maybe_id: Int) -> Result(OwnerId, OwnerIdError) {
  case maybe_id |> validate.is_positive() {
    False -> Error(InvalidId("invalid owner id format"))
    True -> Ok(OwnerId(maybe_id))
  }
}

pub fn decoder(maybe_id: Int) -> decode.Decoder(OwnerId) {
  case create(maybe_id) {
    Error(InvalidId(error)) -> decode.failure(OwnerId(-1), error)
    Ok(value) -> decode.success(value)
  }
}
