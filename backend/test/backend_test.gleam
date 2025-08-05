import dot_env
import gleeunit
import tools/database_setup

pub fn main() -> Nil {
  // Load test env vars
  dot_env.new_with_path("./.env-test") |> dot_env.load()

  // Load database
  let assert Ok(_) = database_setup.prepare_db()

  // Start tests
  gleeunit.main()
}
