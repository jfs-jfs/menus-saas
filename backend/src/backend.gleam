import app/server
import dot_env as dot

pub fn main() -> Nil {
  dot.load_default()
  server.start()
}
