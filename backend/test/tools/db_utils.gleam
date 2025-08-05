import tools/database_setup

pub fn with_clean_db(then: fn() -> Nil) {
  database_setup.roll_back_to_snapshot()
  then()
}
