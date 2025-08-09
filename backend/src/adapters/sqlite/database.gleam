import dot_env/env
import gleam/result
import sqlight

pub fn with_connection(
  error_translate: fn(Result(a, sqlight.Error)) -> Result(a, b),
  then: fn(sqlight.Connection) -> Result(a, b),
) -> Result(a, b) {
  use connection <- result.try(open() |> error_translate())

  let res = then(connection)

  use _ <- result.try(close(connection) |> error_translate())

  res
}

pub fn open() -> Result(sqlight.Connection, sqlight.Error) {
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

pub fn close(connection: sqlight.Connection) -> Result(Nil, sqlight.Error) {
  sqlight.close(connection)
}

pub fn map_error(res: Result(a, sqlight.Error)) -> Result(a, String) {
  res |> result.map_error(fn(err) { err.message })
}
