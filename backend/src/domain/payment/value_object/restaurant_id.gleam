import gleam/dynamic/decode
import shared/validate

pub type RestaurantIdError {
  InvalidId(String)
}

pub type RestaurantId {
  RestaurantId(value: Int)
}

pub fn create(maybe_id: Int) -> Result(RestaurantId, RestaurantIdError) {
  case maybe_id |> validate.is_positive() {
    False -> Error(InvalidId("invalid id format"))
    True -> Ok(RestaurantId(maybe_id))
  }
}

pub fn decoder(maybe_id: Int) -> decode.Decoder(RestaurantId) {
  case create(maybe_id) {
    Error(InvalidId(error)) -> decode.failure(RestaurantId(-1), error)
    Ok(value) -> decode.success(value)
  }
}
