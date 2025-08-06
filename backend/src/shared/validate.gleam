import gleam/bool
import gleam/int
import gleam/order
import gleam/regexp
import gleam/result
import gleam/string

pub const email_pattern = "^[\\w\\-\\.]+@([\\w-]+\\.)+[\\w-]{2,}$"

// Minimum eight characters, at least one upper case English letter, one lower case English letter, one number and one special character 
pub const password_pattern = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}$"

fn regex_check(pattern: String, to_check: String) -> Bool {
  let assert Ok(compiled_regex) = regexp.from_string(pattern)
  regexp.check(compiled_regex, to_check)
}

pub fn is_email(something: String) -> Bool {
  email_pattern
  |> regex_check(something)
}

pub fn is_sha256_hash(something: String) -> Bool {
  string.length(something) == 64
}

pub fn is_password(something: String) -> Bool {
  password_pattern
  |> regex_check(something)
}

pub fn is_positive(n: Int) -> Bool {
  case n |> int.compare(0) {
    order.Gt -> True
    _ -> False
  }
}

pub fn is_nif(maybe_nif: String) -> Bool {
  // TODO
  True
}

pub fn is_postal_code(maybe_postal_code: String) -> Bool {
  bool.and(
    string.length(maybe_postal_code) == 5,
    int.parse(maybe_postal_code) |> result.is_ok(),
  )
}
