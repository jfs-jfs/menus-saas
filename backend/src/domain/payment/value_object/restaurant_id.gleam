import gleam/dynamic/decode
import gleam/result
import shared/value_object/numeric_id

pub type RestaurantIdError =
  numeric_id.NumericIdError

pub type RestaurantId {
  RestaurantId(numeric_id.NumericId)
}

pub fn value(id: RestaurantId) -> Int {
  let RestaurantId(numeric_id.NumericId(value)) = id
  value
}

pub fn create(maybe_id: Int) -> Result(RestaurantId, RestaurantIdError) {
  numeric_id.create(maybe_id) |> result.map(RestaurantId)
}

pub fn decoder(maybe_id: Int) -> decode.Decoder(RestaurantId) {
  use numeric_id <- decode.then(numeric_id.decoder(maybe_id))
  RestaurantId(numeric_id) |> decode.success
}
