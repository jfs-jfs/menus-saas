import domain/payment/value_object/building_number.{type BuildingNumber}
import domain/payment/value_object/city.{type City}
import domain/payment/value_object/postal_code.{type PostalCode}
import domain/payment/value_object/province.{type Province}
import domain/payment/value_object/street_name.{type StreetName}
import gleam/dynamic/decode
import shared/state

pub type InvoiceAddressError

pub type InvoiceAddress {
  InvoiceAddress(
    postal_code: PostalCode,
    province: Province,
    city: City,
    street: StreetName,
    number: BuildingNumber,
  )
}

pub fn create(
  city city: City,
  street street: StreetName,
  province province: Province,
  number number: BuildingNumber,
  postal_code postal_code: PostalCode,
) -> Result(InvoiceAddress, InvoiceAddressError) {
  Ok(InvoiceAddress(postal_code:, city:, street:, province:, number:))
}

pub fn decoder(
  postal_code: PostalCode,
  street: StreetName,
  number: BuildingNumber,
  city: City,
  province: Province,
) -> decode.Decoder(InvoiceAddress) {
  case create(city:, street:, number:, postal_code:, province:) {
    Error(_) -> {
      state.impossible_state_reached(
        "invoice address decoder",
        "can not fail as is aggregate",
      )
    }
    Ok(value) -> decode.success(value)
  }
}
