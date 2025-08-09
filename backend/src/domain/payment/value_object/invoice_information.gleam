import domain/payment/value_object/nif.{type NIF}
import domain/payment/value_object/restaurant_address.{type RestaurantAddress}
import gleam/dynamic/decode
import shared/state

pub type InvoiceInformationError

pub type InvoiceInformation {
  InvoiceInformation(nif: NIF, address: RestaurantAddress)
}

pub fn create(
  nif: NIF,
  address: RestaurantAddress,
) -> Result(InvoiceInformation, InvoiceInformationError) {
  Ok(InvoiceInformation(nif:, address:))
}

pub fn decoder(
  nif: NIF,
  address: RestaurantAddress,
) -> decode.Decoder(InvoiceInformation) {
  case create(nif, address) {
    Error(_) ->
      state.impossible_state_reached(
        "invoice info -> decoder",
        "should not fail as it is an aggregate",
      )
    Ok(value) -> decode.success(value)
  }
}
