import gleam/dynamic/decode
import gleam/result
import shared/value_object/numeric_id

pub type UserIdError =
  numeric_id.NumericIdError

pub type UserId {
  UserId(numeric_id.NumericId)
}

pub fn value(id: UserId) -> Int {
  let UserId(numeric_id.NumericId(value)) = id
  value
}

pub fn create(maybe_id: Int) -> Result(UserId, UserIdError) {
  numeric_id.create(maybe_id) |> result.map(UserId)
}

pub fn decoder(maybe_id: Int) -> decode.Decoder(UserId) {
  use numeric_id <- decode.then(numeric_id.decoder(maybe_id))
  UserId(numeric_id) |> decode.success
}
