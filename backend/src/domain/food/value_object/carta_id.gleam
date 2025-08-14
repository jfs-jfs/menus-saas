import gleam/dynamic/decode
import gleam/result
import shared/value_object/numeric_id

pub type CartaIdError =
  numeric_id.NumericIdError

pub type CartaId {
  CartaId(numeric_id.NumericId)
}

pub fn value(id: CartaId) -> Int {
  let CartaId(numeric_id.NumericId(value)) = id
  value
}

pub fn create(maybe_id: Int) -> Result(CartaId, CartaIdError) {
  numeric_id.create(maybe_id) |> result.map(CartaId)
}

pub fn decoder(maybe_id: Int) -> decode.Decoder(CartaId) {
  use numeric_id <- decode.then(numeric_id.decoder(maybe_id))
  CartaId(numeric_id) |> decode.success
}
