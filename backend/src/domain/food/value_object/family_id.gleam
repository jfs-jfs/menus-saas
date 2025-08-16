import gleam/dynamic/decode
import gleam/result
import shared/value_object/numeric_id

pub type FamilyIdError =
  numeric_id.NumericIdError

pub type FamilyId {
  FamilyId(numeric_id.NumericId)
}

pub fn value(id: FamilyId) -> Int {
  let FamilyId(numeric_id.NumericId(value)) = id
  value
}

pub fn create(maybe_id: Int) -> Result(FamilyId, FamilyIdError) {
  numeric_id.create(maybe_id) |> result.map(FamilyId)
}

pub fn decoder(maybe_id: Int) -> decode.Decoder(FamilyId) {
  use numeric_id <- decode.then(numeric_id.decoder(maybe_id))
  FamilyId(numeric_id) |> decode.success
}
