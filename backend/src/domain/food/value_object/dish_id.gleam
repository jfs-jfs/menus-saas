import gleam/dynamic/decode
import gleam/result
import shared/value_object/numeric_id

pub type DishIdError =
  numeric_id.NumericIdError

pub type DishId {
  DishId(numeric_id.NumericId)
}

pub fn value(id: DishId) -> Int {
  let DishId(numeric_id.NumericId(value)) = id
  value
}

pub fn create(maybe_id: Int) -> Result(DishId, DishIdError) {
  numeric_id.create(maybe_id) |> result.map(DishId)
}

pub fn decoder(maybe_id: Int) -> decode.Decoder(DishId) {
  use numeric_id <- decode.then(numeric_id.decoder(maybe_id))
  DishId(numeric_id) |> decode.success
}
