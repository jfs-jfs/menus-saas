import domain/payment/value_object/business_name.{type BusinessName}
import domain/payment/value_object/city
import domain/payment/value_object/invoice_information.{type InvoiceInformation}
import domain/payment/value_object/owner_id.{type OwnerId}
import domain/payment/value_object/province
import domain/payment/value_object/restaurant_address.{type RestaurantAddress}
import domain/payment/value_object/restaurant_id.{type RestaurantId}
import domain/payment/value_object/street_name
import domain/payment/value_object/telephone.{type Telephone}
import gleam/json
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

pub fn to_json(restaurant: Restaurant) -> json.Json {
  let Restaurant(
    _id,
    _owner_id,
    name:,
    telephone:,
    address:,
    invoice_information:,
  ) = restaurant
  json.object([
    #("name", business_name.to_json(name)),
    #("phone", telephone.to_json(telephone)),
    #("address_province", province.to_json(address.province)),
    #("address_city", city.to_json(address.city)),
    #("address_street", street_name.to_json(address.street)),
    #("invoice", case invoice_information {
      None -> json.null()
      Some(information) -> invoice_information.to_json(information)
    }),
  ])
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
