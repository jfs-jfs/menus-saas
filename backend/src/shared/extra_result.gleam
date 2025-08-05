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
