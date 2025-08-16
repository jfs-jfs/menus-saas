import gleam/dynamic/decode
import gleam/result
import shared/value_object/numeric_id

pub type MenuIdError =
  numeric_id.NumericIdError

pub type MenuId {
  MenuId(numeric_id.NumericId)
}

pub fn value(id: MenuId) -> Int {
  let MenuId(numeric_id.NumericId(value)) = id
  value
}

pub fn create(maybe_id: Int) -> Result(MenuId, MenuIdError) {
  numeric_id.create(maybe_id) |> result.map(MenuId)
}

pub fn decoder(maybe_id: Int) -> decode.Decoder(MenuId) {
  use numeric_id <- decode.then(numeric_id.decoder(maybe_id))
  MenuId(numeric_id) |> decode.success
}
