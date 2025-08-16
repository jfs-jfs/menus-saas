import domain/payment/value_object/building_number
import domain/payment/value_object/business_name
import domain/payment/value_object/city
import domain/payment/value_object/invoice_address
import domain/payment/value_object/invoice_information.{type InvoiceInformation}
import domain/payment/value_object/nif
import domain/payment/value_object/owner_id.{type OwnerId}
import domain/payment/value_object/postal_code
import domain/payment/value_object/province
import domain/payment/value_object/recipient_email
import domain/payment/value_object/recipient_name
import domain/payment/value_object/restaurant_address
import domain/payment/value_object/street_name
import domain/payment/value_object/telephone
import gleam/dynamic/decode.{type Decoder}
import ports/usecases/payment/update_restaurant.{type UpdateRestaurantRequest}

pub fn decoder(owner: OwnerId) -> Decoder(UpdateRestaurantRequest) {
  use name_str <- decode.field("name", decode.string)
  use name <- decode.then(business_name.decoder(name_str))

  use phone_str <- decode.field("phone", decode.string)
  use phone <- decode.then(telephone.decode(phone_str))

  use city_str <- decode.field("address_city", decode.string)
  use city <- decode.then(city.decode(city_str))

  use street_str <- decode.field("address_street", decode.string)
  use street <- decode.then(street_name.decode(street_str))

  use province_str <- decode.field("address_province", decode.string)
  use province <- decode.then(province.decode(province_str))

  use address <- decode.then(restaurant_address.decode(street, city, province))

  use invoice_information <- decode.field(
    "invoice",
    decode.optional(invoice_decoder()),
  )

  decode.success(update_restaurant.UpdateRestaurantRequest(
    owner,
    name,
    phone,
    address,
    invoice_information,
  ))
}

fn invoice_decoder() -> decode.Decoder(InvoiceInformation) {
  use nif_str <- decode.field("nif", decode.string)
  use nif <- decode.then(nif.decoder(nif_str))

  use name_str <- decode.field("recipient", decode.string)
  use name <- decode.then(recipient_name.decode(name_str))

  use email_str <- decode.field("recipient_email", decode.string)
  use email <- decode.then(recipient_email.decode(email_str))

  use city_str <- decode.field("address_city", decode.string)
  use city <- decode.then(city.decode(city_str))

  use street_str <- decode.field("address_street", decode.string)
  use street <- decode.then(street_name.decode(street_str))

  use province_str <- decode.field("address_province", decode.string)
  use province <- decode.then(province.decode(province_str))

  use postal_str <- decode.field("address_postal_code", decode.string)
  use postal <- decode.then(postal_code.decode(postal_str))

  use building_number_str <- decode.field(
    "address_building_number",
    decode.string,
  )
  use building_number <- decode.then(building_number.decoder(
    building_number_str,
  ))

  use address <- decode.then(invoice_address.decoder(
    postal,
    street,
    building_number,
    city,
    province,
  ))

  invoice_information.decoder(nif, name, email, address)
}
