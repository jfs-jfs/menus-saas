import domain/payment/value_object/business_name.{type BusinessName}
import domain/payment/value_object/city.{type City}
import domain/payment/value_object/invoice_information.{type InvoiceInformation}
import domain/payment/value_object/owner_id.{type OwnerId}
import domain/payment/value_object/province
import domain/payment/value_object/restaurant_id.{type RestaurantId}
import domain/payment/value_object/street_name.{type StreetName}
import domain/payment/value_object/telephone.{type Telephone}
import gleam/option.{type Option, None}

pub type Restaurant {
  Restaurant(
    id: Option(RestaurantId),
    owner_id: OwnerId,
    name: BusinessName,
    province: province.Province,
    city: City,
    street: StreetName,
    telephone: Telephone,
    invoice_information: Option(InvoiceInformation),
  )
}

pub fn new(
  owner owner: OwnerId,
  name name: BusinessName,
  provision provision: province.Province,
  city city: City,
  street street: StreetName,
  telephone telephone: Telephone,
  invoice_info invoice_info: Option(InvoiceInformation),
) -> Restaurant {
  Restaurant(
    id: None,
    owner_id: owner,
    name: name,
    province: provision,
    street: street,
    invoice_information: invoice_info,
    telephone: telephone,
    city: city,
  )
}
