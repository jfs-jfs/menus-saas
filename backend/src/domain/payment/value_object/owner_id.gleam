import gleam/dynamic/decode
import gleam/result
import shared/value_object/numeric_id.{NumericId}

pub type OwnerIdError =
  numeric_id.NumericIdError

pub type OwnerId {
  OwnerId(numeric_id.NumericId)
}

pub fn value(id: OwnerId) -> Int {
  let OwnerId(NumericId(value)) = id
  value
}

pub fn create(maybe_id: Int) -> Result(OwnerId, OwnerIdError) {
  numeric_id.create(maybe_id) |> result.map(OwnerId)
}

pub fn decoder(maybe_id: Int) -> decode.Decoder(OwnerId) {
  use numeric_id <- decode.then(numeric_id.decoder(maybe_id))
  OwnerId(numeric_id) |> decode.success
}
