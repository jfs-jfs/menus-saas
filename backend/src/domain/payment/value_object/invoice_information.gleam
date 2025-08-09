import domain/payment/value_object/nif.{type NIF}
import domain/payment/value_object/recipient_email.{type RecipientEmail}
import domain/payment/value_object/recipient_name.{type RecipientName}
import domain/payment/value_object/restaurant_address.{type RestaurantAddress}
import gleam/dynamic/decode
import shared/state

pub type InvoiceInformationError

pub type InvoiceInformation {
  InvoiceInformation(
    nif: NIF,
    name: RecipientName,
    email: RecipientEmail,
    address: RestaurantAddress,
  )
}

pub fn create(
  nif: NIF,
  recipient: RecipientName,
  email: RecipientEmail,
  address: RestaurantAddress,
) -> Result(InvoiceInformation, InvoiceInformationError) {
  Ok(InvoiceInformation(nif:, address:, email:, name: recipient))
}

pub fn decoder(
  nif: NIF,
  to: RecipientName,
  to_email: RecipientEmail,
  address: RestaurantAddress,
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
