import adapters/sqlite/database
import adapters/sqlite/migrator.{type Migration, Migration}
import sqlight.{type Connection}

pub fn build() -> Migration {
  Migration(
    // Needs to be incremented to the newest
    id: 2,
    description: desc(),
    up: up,
    down: down,
  )
}

fn desc() -> String {
  "Creates barebones restaturant table and aggregate invoice information table"
}

fn up(connection: Connection) -> Result(Nil, String) {
  let query =
    "
    BEGIN TRANSACTION;

      CREATE TABLE restaurants (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        owner_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        address_province TEXT NOT NULL,
        address_city TEXT NOT NULL,
        address_street TEXT NOT NULL,
        CONSTRAINT fk_restaurant_user FOREIGN KEY (owner_id) REFERENCES users(id)
      );

      CREATE TABLE restaurant_invoice_information (
        restaurant_id INTEGER NOT NULL,
        nif TEXT NOT NULL,
        recipient_name TEXT NOT NULL,
        recipient_email TEXT NOT NULL,
        address_province TEXT NOT NULL,
        address_postal_code TEXT NOT NULL,
        address_city TEXT NOT NULL,
        address_street TEXT NOT NULL,
        address_building_number TEXT NOT NULL,
        CONSTRAINT fk_invoices FOREIGN KEY (restaurant_id) REFERENCES restaturant(id)
      );

    COMMIT;
  "

  query
  |> sqlight.exec(connection)
  |> database.map_error
}

fn down(connection: Connection) -> Result(Nil, String) {
  let query =
    "
  BEGIN TRANSACTION;

    DROP TABLE invoice_information;
    DROP TABLE restaurants;

  COMMIT;"

  query
  |> sqlight.exec(connection)
  |> database.map_error
}
