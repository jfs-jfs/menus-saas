import domain/payment/value_object/building_number.{type BuildingNumber}
import domain/payment/value_object/postal_code.{type PostalCode}
import domain/payment/value_object/street_name.{type StreetName}

pub type RestaurantAddressError

pub type RestaurantAddress {
  RestaurantAddress(
    postal_code: PostalCode,
    street: StreetName,
    number: BuildingNumber,
  )
}

pub fn create(
  postal_code: postal_code.PostalCode,
  street: street_name.StreetName,
  number: building_number.BuildingNumber,
) -> Result(RestaurantAddress, RestaurantAddressError) {
  Ok(RestaurantAddress(postal_code:, street:, number:))
}
