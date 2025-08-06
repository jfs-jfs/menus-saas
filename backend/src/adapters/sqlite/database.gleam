import dot_env/env
import gleam/result
import sqlight

pub fn open() -> Result(sqlight.Connection, String) {
  use database_uri <- result.try(env.get_string("DATABASE_URI"))

  sqlight.open(database_uri)
  |> result.map_error(fn(error) { error.message })
}

pub fn open_ok() -> Result(sqlight.Connection, sqlight.Error) {
  // use database_uri <- result.try(env.get_string("DATABASE_URI"))

  let maybe_uri =
    env.get_string("DATABASE_URI")
    |> result.map_error(fn(_) {
      sqlight.SqlightError(
        code: sqlight.Cantopen,
        message: "env variable DATABASE_URI not found",
        offset: 0,
      )
    })

  use uri <- result.try(maybe_uri)
  sqlight.open(uri)
}

pub fn close_ok(connection: sqlight.Connection) -> Result(Nil, sqlight.Error) {
  sqlight.close(connection)
}

pub fn close(connection: sqlight.Connection) -> Result(Nil, String) {
  sqlight.close(connection)
  |> result.map_error(fn(error) { error.message })
}

pub fn map_error(res: Result(a, sqlight.Error)) -> Result(a, String) {
  res |> result.map_error(fn(err) { err.message })
}
