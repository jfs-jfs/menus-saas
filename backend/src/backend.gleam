import app/server
import dot_env
import gleam/io
import gleam/result

pub fn main() -> Nil {
  dot_env.load_default()

  server.start()
  |> result.map_error(io.println_error)
  |> result.unwrap(Nil)
}
