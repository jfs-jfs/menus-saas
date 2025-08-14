import gleam/dynamic/decode
import gleam/result
import shared/value_object/numeric_id

pub type PlaceIdError =
  numeric_id.NumericIdError

pub type PlaceId {
  PlaceId(numeric_id.NumericId)
}

pub fn value(id: PlaceId) -> Int {
  let PlaceId(numeric_id.NumericId(value)) = id
  value
}

pub fn create(maybe_id: Int) -> Result(PlaceId, PlaceIdError) {
  numeric_id.create(maybe_id) |> result.map(PlaceId)
}

pub fn decoder(maybe_id: Int) -> decode.Decoder(PlaceId) {
  use numeric_id <- decode.then(numeric_id.decoder(maybe_id))
  PlaceId(numeric_id) |> decode.success
}
