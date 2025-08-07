import domain/payment/value_object/building_number.{BuildingNumber}
import domain/payment/value_object/invoice_information.{InvoiceInformation}
import domain/payment/value_object/nif.{NIF}
import domain/payment/value_object/postal_code.{PostalCode}
import domain/payment/value_object/restaurant_address.{RestaurantAddress}
import domain/payment/value_object/street_name.{StreetName}
import gleeunit/should

pub fn invoice_information_creation_ok_test() {
  let nif = NIF("12345678Z")
  let address =
    RestaurantAddress(
      postal_code: PostalCode("08100"),
      street: StreetName("Rua das Oliveiras"),
      number: BuildingNumber("10A"),
    )

  let assert Ok(InvoiceInformation(nif: result_nif, address: result_address)) =
    invoice_information.create(nif, address)

  result_nif |> should.equal(nif)
  result_address |> should.equal(address)
}
