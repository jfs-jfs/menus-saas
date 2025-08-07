import domain/payment/value_object/building_number.{BuildingNumber}
import domain/payment/value_object/postal_code.{PostalCode}
import domain/payment/value_object/restaurant_address.{RestaurantAddress}
import domain/payment/value_object/street_name.{StreetName}
import gleeunit/should

pub fn restaurant_address_creation_ok_test() {
  let postal_code = PostalCode("08133")
  let street = StreetName("Rua da Liberdade")
  let number = BuildingNumber("42B")

  let assert Ok(RestaurantAddress(postal_code: pc, street: st, number: num)) =
    restaurant_address.create(postal_code, street, number)

  pc |> should.equal(postal_code)
  st |> should.equal(street)
  num |> should.equal(number)
}
