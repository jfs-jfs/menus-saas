import domain/payment/value_object/nif.{type NIF}
import domain/payment/value_object/restaurant_address.{type RestaurantAddress}

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
