import domain/auth/value_objects/password_hash
import gleam/bit_array
import gleam/crypto

pub fn password_hash_creation_ok_test() -> Nil {
  let create_hash = fn(something: String) {
    crypto.Sha256
    |> crypto.hash(bit_array.from_string(something))
    |> bit_array.base16_encode()
  }

  let assert Ok(_) = password_hash.create("hola" |> create_hash)
  let assert Ok(_) = password_hash.create("perola" |> create_hash)

  Nil
}

pub fn password_hash_creation_ko_test() -> Nil {
  let assert Error(error) = password_hash.create("NOTASHA256HASH")

  assert error == "Invalid PasswordHash" as "Wrong error name"

  Nil
}
