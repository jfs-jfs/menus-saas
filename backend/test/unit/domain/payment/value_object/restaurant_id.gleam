import domain/payment/value_object/restaurant_id.{RestaurantId}
import gleam/list
import gleeunit/should

pub fn restaurant_id_creation_ok_test() {
  let valid_ids = [1, 42, 10_000, 938_271, 999_999_999]

  use id <- list.map(valid_ids)
  let assert Ok(RestaurantId(value)) = restaurant_id.create(id)
  value |> should.equal(id)
}

pub fn restaurant_id_creation_ko_test() {
  let invalid_ids = [0, -1, -42, -999, -123_456, -2_000_000]

  use id <- list.map(invalid_ids)
  let assert Error(restaurant_id.InvalidId(msg)) = restaurant_id.create(id)
  msg |> should.equal("invalid restaurant id format")
}
