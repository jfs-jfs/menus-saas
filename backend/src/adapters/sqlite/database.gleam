import dot_env/env
import gleam/result
import sqlight

pub fn open() -> Result(sqlight.Connection, String) {
  use database_uri <- result.try(env.get_string("DATABASE_URI"))

  sqlight.open(database_uri)
  |> result.map_error(fn(error) { error.message })
}

pub fn close(connection: sqlight.Connection) -> Result(Nil, String) {
  sqlight.close(connection)
  |> result.map_error(fn(error) { error.message })
}
