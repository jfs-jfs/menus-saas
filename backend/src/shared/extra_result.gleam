import gleam/dynamic/decode
import gleam/list
import gleam/result

pub fn inspect(res: Result(a, b), func: fn(a) -> Nil) -> Result(a, b) {
  res
  |> result.map(fn(value) {
    func(value)
    value
  })
}

pub fn inspect_error(res: Result(a, b), func: fn(b) -> Nil) -> Result(a, b) {
  res
  |> result.map_error(fn(value) {
    func(value)
    value
  })
}

pub fn from_decode_result(
  res: Result(a, List(decode.DecodeError)),
) -> Result(a, String) {
  use error <- result.map_error(res)

  error
  |> list.first()
  |> result.map(fn(error) {
    "Expected: " <> error.expected <> " Found: " <> error.found
  })
  |> result.unwrap("Empty error list")
}
