import adapters/sqlite/migrator
import app/database_setup
import dot_env/env
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import shared/extra_result
import simplifile
import tools/content_migration

pub fn with_clean_db(then: fn() -> Nil) {
  let res = {
    use <- roll_back_to_snapshot()
    then() |> Ok
  }
  case res {
    Error(err) -> panic as err
    Ok(_) -> Nil
  }
}

pub fn with_test_db(then: fn() -> Nil) {
  use _ <- result.try(prepare_db())

  then()

  use <- delete_db()
  use <- delete_snapshot()
  Nil |> Ok
}

pub fn delete_db(after: fn() -> Result(Nil, String)) -> Result(Nil, String) {
  let database_uri = env.get_string_or("DATABASE_URI", "")
  let assert Ok(database_uri) = database_uri |> string.split(":") |> list.last()
  simplifile.delete(database_uri)
  |> extra_result.inspect_error(fn(err) {
    io.print_error(err |> string.inspect())
  })
  |> result.map_error(fn(_) { "Error deleting db" })
  |> result.map(fn(_) { after() })
  |> result.flatten()
}

pub fn delete_snapshot(
  after: fn() -> Result(Nil, String),
) -> Result(Nil, String) {
  simplifile.delete("test-snapshot")
  |> extra_result.inspect_error(fn(err) {
    io.print_error(err |> string.inspect())
  })
  |> result.map_error(fn(_) { "Error deleting snapshot" })
  |> result.map(fn(_) { after() })
  |> result.flatten()
}

pub fn make_snapshot(after: fn() -> Result(Nil, String)) -> Result(Nil, String) {
  let database_uri = env.get_string_or("DATABASE_URI", "")
  let assert Ok(database_uri) = database_uri |> string.split(":") |> list.last()
  simplifile.copy_file(database_uri, "test-snapshot")
  |> extra_result.inspect_error(fn(err) {
    io.print_error(err |> string.inspect())
  })
  |> result.map_error(fn(_) { "Error deleting snapshot" })
  |> result.map(fn(_) { after() })
  |> result.flatten()
}

pub fn roll_back_to_snapshot(
  after: fn() -> Result(Nil, String),
) -> Result(Nil, String) {
  use <- delete_db()
  let database_uri = env.get_string_or("DATABASE_URI", "")
  let assert Ok(database_uri) = database_uri |> string.split(":") |> list.last()
  simplifile.copy_file("test-snapshot", database_uri)
  |> extra_result.inspect_error(fn(err) {
    io.print_error(err |> string.inspect())
  })
  |> result.map_error(fn(_) { "Error deleting snapshot" })
  |> result.map(fn(_) { after() })
  |> result.flatten()
}

pub fn prepare_db() -> Result(Nil, String) {
  let migrations =
    database_setup.active_migrations()
    |> list.append([content_migration.build()])

  use _ <- result.try(migrator.apply_migrations(migrations))
  use <- make_snapshot()
  Nil |> Ok
}
