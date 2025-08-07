import domain/payment/value_object/street_name.{StreetName}
import gleam/list
import gleeunit/should

pub fn street_name_creation_ok_test() {
  let valid_streets = [
    "Main Street", "Rua das Flores", "Av. da Liberdade", "123 1st Ave",
    "Estrada Nacional 1",
  ]

  use street <- list.map(valid_streets)
  let assert Ok(StreetName(value)) = street_name.create(street)
  value |> should.equal(street)
}

pub fn street_name_creation_ko_test() {
  let invalid_streets = [""]

  use street <- list.map(invalid_streets)
  let assert Error(street_name.InvalidFormat(msg)) = street_name.create(street)
  msg |> should.equal("invalid street format")
}
