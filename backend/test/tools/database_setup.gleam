import adapters/sqlite/migrator
import app/database_setup
import dot_env/env
import gleam/list
import gleam/string
import simplifile
import tools/content_migration

pub fn delete_db() -> Nil {
  let database_uri = env.get_string_or("DATABASE_URI", "")
  let assert Ok(database_uri) = database_uri |> string.split(":") |> list.last()
  let _ = simplifile.delete(database_uri)
  Nil
}

pub fn delete_snapshot() -> Nil {
  let _ = simplifile.delete("test-snapshot")
  Nil
}

pub fn make_snapshot() -> Nil {
  let database_uri = env.get_string_or("DATABASE_URI", "")
  let assert Ok(database_uri) = database_uri |> string.split(":") |> list.last()
  let _ = simplifile.copy_file(database_uri, "test-snapshot")
  Nil
}

pub fn roll_back_to_snapshot() -> Nil {
  delete_db()
  let database_uri = env.get_string_or("DATABASE_URI", "")
  let assert Ok(database_uri) = database_uri |> string.split(":") |> list.last()
  let _ = simplifile.copy_file("test-snapshot", database_uri)
  Nil
}

pub fn prepare_db() -> Result(Nil, String) {
  delete_db()
  delete_snapshot()

  let migrations =
    database_setup.active_migrations()
    |> list.append([content_migration.build()])

  let _ = migrator.apply_migrations(migrations)

  make_snapshot() |> Ok()
}
