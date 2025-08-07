import domain/payment/value_object/postal_code.{PostalCode}
import gleam/list
import gleeunit/should

pub fn postal_code_creation_ok_test() {
  let valid_codes = ["08765", "08221", "08110"]

  use code <- list.map(valid_codes)
  let assert Ok(PostalCode(value)) = postal_code.create(code)
  value |> should.equal(code)
}

pub fn postal_code_creation_ko_test() {
  let invalid_codes = [
    "", "123", "abcd-123", "1234567", "12-3456", "1234-5678", "0000-00",
    "123456", "1000-001", "2000-345", "9999-999", "1234-567", "3000-000",
  ]

  use code <- list.map(invalid_codes)
  let assert Error(postal_code.InvalidFormat(msg)) = postal_code.create(code)
  msg |> should.equal("invalid postal code format")
}
