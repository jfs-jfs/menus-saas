import domain/payment/value_object/building_number.{BuildingNumber}
import domain/payment/value_object/city.{City}
import domain/payment/value_object/invoice_address.{InvoiceAddress}
import domain/payment/value_object/invoice_information.{InvoiceInformation}
import domain/payment/value_object/nif.{NIF}
import domain/payment/value_object/postal_code.{PostalCode}
import domain/payment/value_object/province.{Province}
import domain/payment/value_object/recipient_email
import domain/payment/value_object/recipient_name
import domain/payment/value_object/street_name.{StreetName}
import gleeunit/should

pub fn invoice_information_creation_ok_test() {
  let nif = NIF("12345678Z")
  let city = City("Guarroman")
  let province = Province("")
  let email = recipient_email.RecipientEmail("someone@some.place")
  let recipient = recipient_name.RecipientName("eugenio antonio")
  let address =
    InvoiceAddress(
      city:,
      province:,
      postal_code: PostalCode("08100"),
      street: StreetName("Rua das Oliveiras"),
      number: BuildingNumber("10A"),
    )

  let assert Ok(InvoiceInformation(
    email: result_email,
    name: result_name,
    nif: result_nif,
    address: result_address,
  )) = invoice_information.create(nif, recipient, email, address)

  result_nif |> should.equal(nif)
  result_address |> should.equal(address)
  result_email |> should.equal(email)
  result_name |> should.equal(recipient)
}
