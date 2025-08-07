import domain/payment/value_object/nif.{NIF}
import gleam/list
import gleeunit/should

pub fn nif_creation_ok_test() {
  let valid_nifs = ["12345678Z", "A12345678Z"]

  use nif <- list.map(valid_nifs)
  let assert Ok(NIF(value)) = nif.create(nif)
  value |> should.equal(nif)
}

pub fn nif_creation_ko_test() {
  let invalid_nifs = [
    "", "abc", "123", "12345678", "A1234567890", "12A45678901", "24598765",
    "2983740", "00000",
  ]

  use nif <- list.map(invalid_nifs)
  let assert Error(nif.InvalidNIF(msg)) = nif.create(nif)
  msg |> should.equal("invalid NIF format")
}
