import dot_env
import glacier
import gleam/io
import tools/database_setup

pub fn main() {
  dot_env.new_with_path("./.env-test") |> dot_env.load()

  let res = {
    use <- database_setup.with_test_db()

    // Nothing executes after this function
    glacier.main()
  }

  case res {
    Error(error) -> io.println_error(error)
    Ok(_) -> Nil
  }
}
