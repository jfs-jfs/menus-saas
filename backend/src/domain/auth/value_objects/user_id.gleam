import gleam/dynamic/decode
import shared/validate

pub type UserIdError {
  InvalidId(String)
}

pub type UserId {
  UserId(value: Int)
}

pub fn create(maybe_id: Int) -> Result(UserId, UserIdError) {
  case maybe_id |> validate.is_positive() {
    True -> Ok(UserId(maybe_id))
    False -> Error(InvalidId("invalid user id format"))
  }
}

pub fn decoder(maybe_id: Int) -> decode.Decoder(UserId) {
  case create(maybe_id) {
    Error(InvalidId(error)) -> decode.failure(UserId(-1), error)
    Ok(value) -> decode.success(value)
  }
}
