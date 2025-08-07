import domain/payment/value_object/building_number.{BuildingNumber}
import gleam/list
import gleeunit/should

pub fn building_number_creation_ok_test() {
  let valid_numbers = ["1", "12A", "100-B", "42", "23C"]

  use number <- list.map(valid_numbers)
  let assert Ok(BuildingNumber(value)) = building_number.create(number)
  value |> should.equal(number)
}

pub fn building_number_creation_ko_test() {
  let invalid_numbers = [""]

  use number <- list.map(invalid_numbers)
  let assert Error(building_number.InvalidFormat(msg)) =
    building_number.create(number)
  msg |> should.equal("invalid building number format")
}
