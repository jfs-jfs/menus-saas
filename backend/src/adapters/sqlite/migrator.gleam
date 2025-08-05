import adapters/sqlite/database
import gleam/dynamic/decode
import gleam/int
import gleam/list
import gleam/result
import shared/extra_result
import sqlight.{type Connection}
import wisp

pub type Migration {
  Migration(
    id: Int,
    description: String,
    up: fn(Connection) -> Result(Nil, String),
    down: fn(Connection) -> Result(Nil, String),
  )
}

const migration_table_sql = "CREATE TABLE IF NOT EXISTS __migrations (
  id INTEGER PRIMARY KEY,
  description TEXT NOT NULL,
  applied_at DATETIME DEFAULT CURRENT_TIMESTAMP
)"

fn try_create_migration_table(
  on_created: fn() -> Result(Nil, String),
) -> Result(Nil, String) {
  use connection <- result.try(database.open())

  let res =
    migration_table_sql
    |> sqlight.exec(connection)
    |> result.map_error(fn(err) { err.message })

  use _ <- result.try(database.close(connection))
  use _ <- result.try(res)

  on_created()
}

pub fn apply_migrations(migrations: List(Migration)) -> Result(Nil, String) {
  use <- try_create_migration_table()

  use connection <- result.try(database.open())
  use applied_migrations <- result.try(applied_migrations_ids(connection))

  wisp.log_info("Starting to apply migrations")

  let res =
    migrations
    |> list.fold_until(Ok(Nil), fn(_, migration) {
      case execute_migration(migration, applied_migrations, connection) {
        Error(error) -> list.Stop(Error(error))
        Ok(_) -> list.Continue(Ok(Nil))
      }
    })

  use _ <- result.try(database.close(connection))

  res
  |> extra_result.inspect(fn(_) {
    wisp.log_info("Migration ended successfully")
  })
  |> extra_result.inspect_error(fn(error) {
    wisp.log_critical("Unable to finish migration due to: " <> error)
  })
}

pub fn remove_migrations(
  migrations: List(Migration),
  amount: Int,
) -> Result(Nil, String) {
  use <- try_create_migration_table()

  use connection <- result.try(database.open())
  use applied_migrations <- result.try(applied_migrations_ids(connection))

  let res =
    migrations
    |> list.reverse()
    |> list.fold_until(Ok(amount), fn(ok, migration) {
      let assert Ok(amount) = ok
      case amount, remove_migration(migration, applied_migrations, connection) {
        amount, Ok(_) -> list.Continue(Ok(amount - 1))
        amount, _ if amount <= 0 -> list.Stop(Ok(0))
        _, Error(error) -> list.Stop(Error(error))
      }
    })
    |> result.map(fn(_) { Nil })

  use _ <- result.try(database.close(connection))
  res
}

fn applied_migrations_ids(connection: Connection) -> Result(List(Int), String) {
  "SELECT id FROM __migrations ORDER BY id"
  |> sqlight.query(connection, [], decode.at([0], decode.int))
  |> result.map_error(fn(err) { err.message })
}

fn execute_migration(
  migration: Migration,
  applied_migrations: List(Int),
  connection: Connection,
) -> Result(Nil, String) {
  applied_migrations
  |> list.find(fn(id) { migration.id == id })
  |> result.map(fn(_) {
    wisp.log_info(
      "Skipping Migration id: "
      <> migration.id |> int.to_string()
      <> " already migrated",
    )
  })
  |> result.try_recover(fn(_) {
    use _ <- result.try(migration.up(connection))
    mark_migrated(migration, connection)
  })
  |> result.map_error(fn(err) {
    "migration id: " <> migration.id |> int.to_string() <> " :: " <> err
  })
}

fn mark_migrated(
  migration: Migration,
  connection: Connection,
) -> Result(Nil, String) {
  "INSERT INTO __migrations(id, description) VALUES ( ? , ? )"
  |> sqlight.query(
    connection,
    [sqlight.int(migration.id), sqlight.text(migration.description)],
    decode.dynamic,
  )
  |> result.map(fn(_) { Nil })
  |> result.map_error(fn(err) { err.message })
  |> extra_result.inspect(fn(_) {
    wisp.log_info(
      "Migrated successfully Migration id: " <> migration.id |> int.to_string(),
    )
  })
}

fn remove_migrated_mark(
  migration: Migration,
  connection: Connection,
) -> Result(Nil, String) {
  "DELETE FROM __migrations WHERE id = ?"
  |> sqlight.query(connection, [sqlight.int(migration.id)], decode.dynamic)
  |> result.map(fn(_) { Nil })
  |> result.map_error(fn(err) { err.message })
}

fn remove_migration(
  migration: Migration,
  applied_migrations: List(Int),
  connection: Connection,
) -> Result(Nil, String) {
  applied_migrations
  |> list.find(fn(id) { migration.id == id })
  |> result.map_error(fn(_) {
    "Tried to remove non applied migration: " <> migration.id |> int.to_string()
  })
  |> result.map(fn(_) {
    use _ <- result.try(migration.down(connection))
    remove_migrated_mark(migration, connection)
  })
  |> result.flatten()
}
