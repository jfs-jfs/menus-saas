import adapters/sqlite/database
import adapters/sqlite/migrator.{type Migration, Migration}
import sqlight.{type Connection}

pub fn build() -> Migration {
  Migration(
    // Needs to be incremented to the newest
    id: 1,
    description: desc(),
    up: up,
    down: down,
  )
}

fn desc() -> String {
  "Creates barebones user table."
}

fn up(connection: Connection) -> Result(Nil, String) {
  let query =
    "CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT NOT NULL UNIQUE,
    hash TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  )"

  query
  |> sqlight.exec(connection)
  |> database.map_error
}

fn down(connection: Connection) -> Result(Nil, String) {
  let query = "DROP TABLE users"

  query
  |> sqlight.exec(connection)
  |> database.map_error
}
