import domain/payment/value_object/business_name.{BusinessName}
import gleam/list
import gleeunit/should

pub fn business_name_creation_ok_test() {
  let valid_names = [
    "Acme Corp", "Supermercado Central", "John & Sons Ltd.", "TechNova",
    "Restaurante O Galo",
  ]

  use name <- list.map(valid_names)
  let assert Ok(BusinessName(value)) = business_name.create(name)
  value |> should.equal(name)
}

pub fn business_name_creation_ko_test() {
  let invalid_names = [""]

  use name <- list.map(invalid_names)
  let assert Error(business_name.InvalidName(msg)) = business_name.create(name)
  msg |> should.equal("invalid business name format")
}
