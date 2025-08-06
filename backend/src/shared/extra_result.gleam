import gleam/dynamic/decode
import gleam/list
import gleam/result
import gleam/string

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

pub fn to_nil(res: Result(a, b)) -> Result(Nil, b) {
  res |> result.map(fn(_) { Nil })
}

pub fn from_decode_result(
  res: Result(a, List(decode.DecodeError)),
) -> Result(a, String) {
  use errors <- result.map_error(res)
  list.map(errors, fn(error) {
    case error.path {
      [] -> error.expected
      _ ->
        error.path |> string.inspect()
        <> " :: "
        <> error.expected
        <> " was expected but found "
        <> error.found
    }
  })
  |> list.map(string.lowercase)
  |> list.fold("", fn(acc, error) { acc <> error <> "\n" })
}
