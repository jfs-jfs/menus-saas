import dot_env
import gleam/io
import gleeunit
import tools/database_setup

pub fn main() {
  dot_env.new_with_path("./.env-test") |> dot_env.load()

  let res = {
    use <- database_setup.with_test_db()

    gleeunit.main()
  }

  case res {
    Error(error) -> io.println_error(error)
    Ok(_) -> Nil
  }
}
