import gleam/regexp

pub const email_pattern = "^[\\w\\-\\.]+@([\\w-]+\\.)+[\\w-]{2,}$"

pub const sha256_pattern = "^[a-fA-F0-9]{64}$"

fn regex_check(pattern: String, to_check: String) -> Bool {
  let assert Ok(compiled_regex) = regexp.from_string(pattern)
  regexp.check(compiled_regex, to_check)
}

pub fn is_email(something: String) -> Bool {
  email_pattern
  |> regex_check(something)
}

pub fn is_sha256_hash(something: String) -> Bool {
  sha256_pattern
  |> regex_check(something)
}
