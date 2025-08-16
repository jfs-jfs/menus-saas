import gleam/dynamic/decode
import gleam/result
import shared/value_object/numeric_id

pub type EstablishmentIdError =
  numeric_id.NumericIdError

pub type EstablishmentId {
  EstablishmentId(numeric_id.NumericId)
}

pub fn value(id: EstablishmentId) -> Int {
  let EstablishmentId(numeric_id.NumericId(value)) = id
  value
}

pub fn create(maybe_id: Int) -> Result(EstablishmentId, EstablishmentIdError) {
  numeric_id.create(maybe_id) |> result.map(EstablishmentId)
}

pub fn decoder(maybe_id: Int) -> decode.Decoder(EstablishmentId) {
  use numeric_id <- decode.then(numeric_id.decoder(maybe_id))
  EstablishmentId(numeric_id) |> decode.success
}
