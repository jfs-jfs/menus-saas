import gleam/dynamic/decode
import shared/validate

pub type NumericIdError {
  InvalidId(String)
}

pub type NumericId {
  NumericId(value: Int)
}

pub fn create(maybe_id: Int) -> Result(NumericId, NumericIdError) {
  case maybe_id |> validate.is_positive() {
    True -> Ok(NumericId(maybe_id))
    False -> Error(InvalidId("invalid id format"))
  }
}

pub fn decoder(maybe_id: Int) -> decode.Decoder(NumericId) {
  case create(maybe_id) {
    Error(InvalidId(error)) -> decode.failure(NumericId(-1), error)
    Ok(value) -> decode.success(value)
  }
}
