import domain/payment/value_object/province.{Province}
import gleam/list
import gleeunit/should

pub fn province_ok_test() {
  // To think better names
  let valid_names = ["somewhere", "barcelona", "manresa"]

  use name <- list.map(valid_names)
  let assert Ok(Province(value)) = province.create(name)
  value |> should.equal(name)
}

pub fn province_ko_test() {
  let invalid_names = [""]

  use name <- list.map(invalid_names)
  let assert Error(province.InvalidProvince(msg)) = province.create(name)
  msg |> should.equal("invalid province")
}
