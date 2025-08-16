import gleam/string

pub fn contain(in: String, this: String) -> Nil {
  case string.contains(in, this) {
    True -> Nil
    False -> panic as string.concat(["\n", in, "\nshould contain\n", this])
  }
}

pub fn not_contain(in: String, this: String) -> Nil {
  case string.contains(in, this) {
    False -> Nil
    True -> panic as string.concat(["\n", in, "\nshould not contain\n", this])
  }
}
