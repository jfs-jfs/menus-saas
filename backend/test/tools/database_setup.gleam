import adapters/sqlite/migrator
import app/database_setup
import dot_env/env
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile
import tools/content_migration

const snapshot_location = "test/artifacts/snapshot.db"

pub fn with_clean_db(then: fn() -> Nil) {
  let res = {
    use <- rollback_to_snapshot()
    then() |> Ok
  }
  case res {
    Error(err) -> panic as err
    Ok(_) -> Nil
  }
}

pub fn with_test_db(then: fn() -> Nil) {
  case delete_db(fn() { Ok(Nil) }) {
    Error(err) -> io.println_error("delete_db :: " <> err)
    Ok(_) -> Nil
  }
  case delete_snapshot(fn() { Ok(Nil) }) {
    Error(err) -> io.println_error("delete_snapshot :: " <> err)
    Ok(_) -> Nil
  }
  case prepare_db() {
    Error(err) -> io.println_error("prepare_db :: " <> err)
    Ok(_) -> Nil
  }

  // Nothing will execute after the then as it calls the gleeunit.main() and that
  // one will forcefully halt the program after invocation.
  // Things under are so it compiles
  then()

  Nil |> Ok
}

pub fn delete_db(after: fn() -> Result(Nil, String)) -> Result(Nil, String) {
  let database_uri = env.get_string_or("DATABASE_URI", "")
  let assert Ok(database_uri) = database_uri |> string.split(":") |> list.last()
  simplifile.delete(database_uri)
  |> result.map_error(fn(_) { "Error deleting db" })
  |> result.map(fn(_) { after() })
  |> result.flatten()
}

pub fn delete_snapshot(
  after: fn() -> Result(Nil, String),
) -> Result(Nil, String) {
  simplifile.delete(snapshot_location)
  |> result.map_error(fn(_) { "Error deleting snapshot" })
  |> result.map(fn(_) { after() })
  |> result.flatten()
}

pub fn make_snapshot(after: fn() -> Result(Nil, String)) -> Result(Nil, String) {
  let database_uri = env.get_string_or("DATABASE_URI", "")
  let assert Ok(database_uri) = database_uri |> string.split(":") |> list.last()
  simplifile.copy_file(database_uri, snapshot_location)
  |> result.map_error(fn(_) { "Error creating snapshot" })
  |> result.map(fn(_) { after() })
  |> result.flatten()
}

pub fn rollback_to_snapshot(
  after: fn() -> Result(Nil, String),
) -> Result(Nil, String) {
  use <- delete_db()
  let database_uri = env.get_string_or("DATABASE_URI", "")
  let assert Ok(database_uri) = database_uri |> string.split(":") |> list.last()
  simplifile.copy_file(snapshot_location, database_uri)
  |> result.map_error(fn(_) { "Error rollingback to snapshot" })
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
