import domain/payment/value_object/business_name.{type BusinessName}
import domain/payment/value_object/invoice_information.{type InvoiceInformation}
import domain/payment/value_object/owner_id.{type OwnerId}
import domain/payment/value_object/restaurant_address.{type RestaurantAddress}
import domain/payment/value_object/restaurant_id.{type RestaurantId}
import domain/payment/value_object/telephone.{type Telephone}
import gleam/option.{type Option, None, Some}

pub type RestaurantError {
  AlreadyHasInvoiceInformation
}

pub type Restaurant {
  Restaurant(
    id: Option(RestaurantId),
    owner_id: OwnerId,
    name: BusinessName,
    telephone: Telephone,
    address: RestaurantAddress,
    invoice_information: Option(InvoiceInformation),
  )
}

pub fn new(
  owner owner: OwnerId,
  name name: BusinessName,
  address address: RestaurantAddress,
  telephone telephone: Telephone,
  invoice_info invoice_info: Option(InvoiceInformation),
) -> Restaurant {
  Restaurant(
    id: None,
    owner_id: owner,
    name: name,
    invoice_information: invoice_info,
    telephone: telephone,
    address: address,
  )
}

pub fn add_invoice_information(
  restaurant: Restaurant,
  invoice_information: InvoiceInformation,
) -> Result(Restaurant, RestaurantError) {
  case restaurant.invoice_information {
    Some(_) -> Error(AlreadyHasInvoiceInformation)
    None ->
      Restaurant(
        id: restaurant.id,
        owner_id: restaurant.owner_id,
        name: restaurant.name,
        telephone: restaurant.telephone,
        address: restaurant.address,
        invoice_information: Some(invoice_information),
      )
      |> Ok
  }
}
