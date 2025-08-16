import domain/payment/value_object/owner_id.{OwnerId}
import gleam/list
import gleeunit/should
import shared/value_object/numeric_id.{NumericId}

pub fn owner_id_creation_ok_test() {
  let valid_ids = [1, 982_734, 23_423, 238_472_398_472, 9]

  use id <- list.map(valid_ids)
  let assert Ok(OwnerId(NumericId(value))) = owner_id.create(id)
  value |> should.equal(id)
}

pub fn owner_id_creation_ko_test() {
  let invalid_ids = [0, -1, -1231, -123_123, -123_123_123, -854]

  use id <- list.map(invalid_ids)
  let assert Error(_) = owner_id.create(id)
}
