import adapters/sqlite/database
import domain/payment/restaurant.{type Restaurant, Restaurant}
import domain/payment/value_object/business_name
import domain/payment/value_object/city
import domain/payment/value_object/invoice_information.{
  type InvoiceInformation, InvoiceInformation,
}
import domain/payment/value_object/owner_id
import domain/payment/value_object/province
import domain/payment/value_object/restaurant_id
import domain/payment/value_object/telephone
import gleam/dynamic/decode
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import ports/repositories/restaurant_repository.{
  type RestaurantRepository, type RestaurantRepositoryError, RestaurantNotFound,
  RestaurantRepository,
}
import shared/extra_result
import sqlight

pub fn build() -> RestaurantRepository {
  RestaurantRepository(save:)
}

fn save(entity: Restaurant) -> Result(Restaurant, RestaurantRepositoryError) {
  case entity.id {
    None -> create(entity)
    Some(_) -> update(entity)
  }
}

fn update(entity: Restaurant) -> Result(Restaurant, RestaurantRepositoryError) {
  todo
}

fn create(entity: Restaurant) -> Result(Restaurant, RestaurantRepositoryError) {
  let Restaurant(
    _id,
    owner_id:,
    name:,
    telephone:,
    address:,
    invoice_information:,
  ) = entity
  use connection <- result.try(database.open() |> translate_error())

  let res =
    "
  INSERT INTO restaurants(
    owner_id, name, phone,
    address_province,
    address_city,
    address_street
  ) VALUES (?, ?, ?, ?, ?, ?)
  "
    |> sqlight.query(
      connection,
      [
        sqlight.int(owner_id |> owner_id.value()),
        sqlight.text(name.value),
        sqlight.text(telephone.value),
        sqlight.text(address.province.value),
        sqlight.text(address.city.value),
        sqlight.text(address.street.value),
      ],
      decode.dynamic,
    )
    |> translate_error()
    |> extra_result.to_nil()

  use _ <- result.try(database.close(connection) |> translate_error())
  use _ <- result.try(res)

  let res = search_by_owner(owner_id)

  case invoice_information {
    None -> res
    Some(_) -> create_invoice_information(entity)
  }
}

fn create_invoice_information(
  entity: Restaurant,
) -> Result(Restaurant, RestaurantRepositoryError) {
  let assert Restaurant(Some(id), _, _, _, _, Some(invoice_information)) =
    entity
  let InvoiceInformation(nif, name, email, address) = invoice_information
  use connection <- database.with_connection(translate_error)

  "
  INSERT INTO restaurant_invoice_information (
    restaurant_id,
    nif,
    recipient_name,
    recipient_email,
    address_province,
    address_postal_code,
    address_city,
    address_street,
    address_building_number
  ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  "
  |> sqlight.query(
    connection,
    [
      sqlight.int(id |> restaurant_id.value()),
      sqlight.text(nif.value),
      sqlight.text(name.value),
      sqlight.text(email.value),
      sqlight.text(address.province.value),
      sqlight.text(address.postal_code.value),
      sqlight.text(address.city.value),
      sqlight.text(address.number.value),
    ],
    decode.dynamic,
  )
  |> translate_error()
  |> result.map(fn(_) { entity })
}

fn search_by_owner(
  id: owner_id.OwnerId,
) -> Result(Restaurant, RestaurantRepositoryError) {
  use connection <- database.with_connection(translate_error)
  "
  SELECT 
    r.id,
    r.owner_id,
    r.name,
    r.phone,
    r.address_province,
    r.address_city,
    r.address_street,
    rii.restaurant_id,
    rii.nif,
    rii.recipient_name,
    rii.recipient_email,
    rii.address_province,
    rii.address_postal_code,
    rii.address_city,
    rii.address_street,
    rii.address_building_number
  FROM 
    restaurants r
  LEFT JOIN 
    restaurant_invoice_information rii
    ON r.id = rii.restaurant_id
  WHERE 
    r.owner_id = ?
  LIMIT 1;
  "
  |> sqlight.query(
    connection,
    [sqlight.int(id |> owner_id.value())],
    decode_restaurant(),
  )
  |> translate_error()
  |> result.map(fn(restaurants) {
    restaurants
    |> list.first()
    |> result.map_error(fn(_) { RestaurantNotFound })
  })
  |> result.flatten()
}

fn translate_error(
  res: Result(a, sqlight.Error),
) -> Result(a, RestaurantRepositoryError) {
  todo
}

fn decode_restaurant() -> decode.Decoder(Restaurant) {
  use id_int <- decode.field(0, decode.int)
  use id <- decode.then(restaurant_id.decoder(id_int))

  use owner_int <- decode.field(1, decode.int)
  use owner <- decode.then(owner_id.decoder(owner_int))

  use name_str <- decode.field(2, decode.string)
  use name <- decode.then(business_name.decoder(name_str))

  use phone_str <- decode.field(3, decode.string)
  use phone <- decode.then(telephone.decode(phone_str))

  use province_str <- decode.field(4, decode.string)
  use province <- decode.then(province.decode(province_str))

  use city_str <- decode.field(5, decode.string)
  use city <- decode.then(city.decode(city_str))

  todo
}

fn deocde_invoice_info() -> decode.Decoder(InvoiceInformation) {
  todo
}
