import domain/payment/value_object/building_number.{type BuildingNumber}
import domain/payment/value_object/postal_code.{type PostalCode}
import domain/payment/value_object/street_name.{type StreetName}
import gleam/dynamic/decode
import shared/state

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

pub fn decoder(
  postal_code: postal_code.PostalCode,
  street: street_name.StreetName,
  number: building_number.BuildingNumber,
) -> decode.Decoder(RestaurantAddress) {
  case create(postal_code, street, number) {
    Error(_) -> {
      state.impossible_state_reached(
        "restaurant address decoder",
        "can not fail as is aggregate",
      )
    }
    Ok(value) -> decode.success(value)
  }
}
