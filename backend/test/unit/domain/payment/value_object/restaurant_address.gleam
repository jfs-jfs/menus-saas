import domain/payment/value_object/city.{City}
import domain/payment/value_object/province
import domain/payment/value_object/restaurant_address.{RestaurantAddress}
import domain/payment/value_object/street_name.{StreetName}
import gleeunit/should

pub fn restaurant_address_creation_ok_test() {
  let street = StreetName("Rua da Liberdade")
  let city = City("Barcelona")
  let province = province.Province("Barcelona")

  let assert Ok(RestaurantAddress(street: st, city: cc, province: pv)) =
    restaurant_address.create(city, street, province)

  st |> should.equal(street)
  cc |> should.equal(city)
  pv |> should.equal(province)
}
