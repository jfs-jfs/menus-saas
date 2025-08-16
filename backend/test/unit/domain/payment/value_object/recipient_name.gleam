import domain/payment/value_object/recipient_name
import gleam/list
import gleeunit/should

pub fn recipient_name_creation_ok_test() {
  let valid_names = [
    "Joan Pere", "Ma. Angustias del Monte", "Antonio Figuerola",
  ]

  use name <- list.map(valid_names)
  let assert Ok(recipient_name.RecipientName(value)) =
    recipient_name.create(name)
  value |> should.equal(name)
}

pub fn recipient_name_creation_ko_test() {
  let invalid_names = [""]

  use name <- list.map(invalid_names)
  let assert Error(recipient_name.InvalidName(msg)) =
    recipient_name.create(name)
  msg |> should.equal("invalid recipient name")
}
