import domain/payment/value_object/building_number
import domain/payment/value_object/city
import domain/payment/value_object/invoice_address.{type InvoiceAddress}
import domain/payment/value_object/nif.{type NIF}
import domain/payment/value_object/postal_code
import domain/payment/value_object/province
import domain/payment/value_object/recipient_email.{type RecipientEmail}
import domain/payment/value_object/recipient_name.{type RecipientName}
import domain/payment/value_object/street_name
import gleam/dynamic/decode
import gleam/json
import shared/state

pub type InvoiceInformationError

pub type InvoiceInformation {
  InvoiceInformation(
    nif: NIF,
    name: RecipientName,
    email: RecipientEmail,
    address: InvoiceAddress,
  )
}

pub fn to_json(invoice_information: InvoiceInformation) -> json.Json {
  let InvoiceInformation(nif:, name:, email:, address:) = invoice_information
  json.object([
    #("nif", nif.to_json(nif)),
    #("recipient", recipient_name.to_json(name)),
    #("recipient_email", recipient_email.to_json(email)),
    #("address_province", province.to_json(address.province)),
    #("address_postal_code", postal_code.to_json(address.postal_code)),
    #("address_city", city.to_json(address.city)),
    #("address_street", street_name.to_json(address.street)),
    #("address_building_number", building_number.to_json(address.number)),
  ])
}

pub fn create(
  nif: NIF,
  recipient: RecipientName,
  email: RecipientEmail,
  address: InvoiceAddress,
) -> Result(InvoiceInformation, InvoiceInformationError) {
  Ok(InvoiceInformation(nif:, address:, email:, name: recipient))
}

pub fn decoder(
  nif: NIF,
  to: RecipientName,
  to_email: RecipientEmail,
  address: InvoiceAddress,
) -> decode.Decoder(InvoiceInformation) {
  case create(nif, to, to_email, address) {
    Ok(value) -> decode.success(value)
    Error(_) ->
      state.impossible_state_reached(
        "invoice info -> decoder",
        "should not fail as it is an aggregate",
      )
  }
}
