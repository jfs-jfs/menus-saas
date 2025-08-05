import adapters/sqlite/migrator

const active_migrations = []

pub fn setup() -> Result(Nil, String) {
  migrator.apply_migrations(active_migrations)
}
