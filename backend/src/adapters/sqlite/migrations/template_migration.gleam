import adapters/sqlite/database
import adapters/sqlite/migrator.{type Migration, Migration}
import sqlight.{type Connection}

pub fn build() -> Migration {
  Migration(
    // Needs to be incremented to the newest
    id: 0,
    description: desc(),
    up: up,
    down: down,
  )
}

fn desc() -> String {
  "<MIGRATION DESCRIPTION>"
}

fn up(connection: Connection) -> Result(Nil, String) {
  let query = ""

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
