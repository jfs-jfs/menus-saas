import adapters/sqlite/database
import adapters/sqlite/migrator.{type Migration, Migration}
import sqlight.{type Connection}

pub fn build() -> Migration {
  Migration(id: 2_000_000, description: desc(), up: up, down: down)
}

fn desc() -> String {
  "Content for testing"
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
