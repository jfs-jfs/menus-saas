import domain/payment/value_object/city.{type City}
import domain/payment/value_object/province.{type Province}
import domain/payment/value_object/street_name.{type StreetName}
import gleam/dynamic/decode
import shared/state

pub type RestaurantAddressError

pub type RestaurantAddress {
  RestaurantAddress(province: Province, city: City, street: StreetName)
}

pub fn create(
  city city: City,
  street street: StreetName,
  province province: Province,
) -> Result(RestaurantAddress, RestaurantAddressError) {
  Ok(RestaurantAddress(city:, street:, province:))
}

pub fn decoder(
  street: StreetName,
  city: City,
  province: Province,
) -> decode.Decoder(RestaurantAddress) {
  case create(city:, street:, province:) {
    Error(_) -> {
      state.impossible_state_reached(
        "restaurant address decoder",
        "can not fail as is aggregate",
      )
    }
    Ok(value) -> decode.success(value)
  }
}
