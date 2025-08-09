import domain/payment/value_object/city.{City}
import gleam/list
import gleeunit/should

pub fn city_ok_test() {
  let valid_names = ["venice", "california", "barcelona"]

  use name <- list.map(valid_names)
  let assert Ok(City(value)) = city.create(name)
  value |> should.equal(name)
}

pub fn city_ko_test() {
  let invalid_names = [""]

  use name <- list.map(invalid_names)
  let assert Error(city.UnknownCity(msg)) = city.create(name)
  msg |> should.equal("unknown city")
}
