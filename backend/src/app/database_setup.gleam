import adapters/sqlite/migrations/m0001
import adapters/sqlite/migrations/m0002
import adapters/sqlite/migrator.{type Migration}

pub fn active_migrations() -> List(Migration) {
  [m0001.build(), m0002.build()]
}

pub fn setup() -> Result(Nil, String) {
  migrator.apply_migrations(active_migrations())
}
