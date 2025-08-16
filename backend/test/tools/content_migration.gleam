import adapters/sqlite/database
import adapters/sqlite/migrator.{type Migration, Migration}
import sqlight.{type Connection}
import tools/db_utils

pub fn build() -> Migration {
  Migration(id: 2_000_000, description: desc(), up: up, down: down)
}

fn desc() -> String {
  "Content for testing"
}

fn up(connection: Connection) -> Result(Nil, String) {
  let query = "
  BEGIN TRANSACTION;

    --; users
    INSERT INTO 
      users(id, email, hash)
    VALUES (
      1,
      '" <> db_utils.registered_user_email() <> "',
      '" <> db_utils.registered_user_hash() <> "'
    ),
    (
      2,
      '" <> db_utils.user_no_restaurant_email() <> "',
      '" <> db_utils.user_no_restaurant_hash() <> "'
    ),
    (
      3,
      '" <> db_utils.user_no_invoice_info_email() <> "',
      '" <> db_utils.user_no_invoice_info_hash() <> "'
    ),
    (
      4,
      '" <> db_utils.user_full_restaurant_email() <> "',
      '" <> db_utils.user_full_restaurant_hash() <> "'
    );

    --; restaurants
    INSERT INTO
      restaurants(
        id,
        owner_id,
        name,
        phone,
        address_province,
        address_city,
        address_street
      )
    VALUES (
      1,
      3,
      'no invoice restaurant',
      '" <> db_utils.get_phone() <> "',
      '" <> db_utils.get_province() <> "',
      '" <> db_utils.get_city() <> "',
      '" <> db_utils.get_street() <> "'
    ),
    (
      2,
      4,
      'with invoice information',
      '" <> db_utils.get_phone() <> "',
      '" <> db_utils.get_province() <> "',
      '" <> db_utils.get_city() <> "',
      '" <> db_utils.get_street() <> "'
    );

    INSERT INTO
      restaurant_invoice_information(
        restaurant_id,
        nif,
        recipient_name,
        recipient_email,
        address_province,
        address_postal_code,
        address_city,
        address_street,
        address_building_number
      )
    VALUES (
      2,
      '" <> db_utils.get_nif() <> "',
      '" <> db_utils.get_name() <> "',
      '" <> db_utils.get_email() <> "',
      '" <> db_utils.get_province() <> "',
      '" <> db_utils.get_postal_code() <> "',
      '" <> db_utils.get_city() <> "',
      '" <> db_utils.get_street() <> "',
      '" <> db_utils.get_building_number() <> "'
    );

  COMMIT;
  "

  query
  |> sqlight.exec(connection)
  |> database.map_error
}

fn down(connection: Connection) -> Result(Nil, String) {
  let query = ""

  query
  |> sqlight.exec(connection)
  |> database.map_error
}
