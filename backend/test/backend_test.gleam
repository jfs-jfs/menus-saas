import dot_env
import gleeunit

pub fn main() -> Nil {
  // Load test env vars
  dot_env.new_with_path("./.env-test") |> dot_env.load()

  // Start tests
  gleeunit.main()
}
