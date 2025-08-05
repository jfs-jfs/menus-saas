import adapters/hasher/sha256_hasher
import domain/auth/value_objects/password_hash.{
  InvalidHashFormat, InvalidPasswordFormat,
}
import gleam/bit_array
import gleam/crypto
import gleeunit/should

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
  let assert Error(InvalidHashFormat(error)) =
    password_hash.create("NOTASHA256HASH")

  should.equal("invalid hash format", error)
}

pub fn password_creation_ko_test() -> Nil {
  let assert InvalidPasswordFormat(_) =
    should.be_error(password_hash.from_plaintext("hola", sha256_hasher.build()))
  let assert InvalidPasswordFormat(_) =
    should.be_error(password_hash.from_plaintext(
      "HOLAPEROLA",
      sha256_hasher.build(),
    ))
  let assert InvalidPasswordFormat(_) =
    should.be_error(password_hash.from_plaintext(
      "HOLA!@",
      sha256_hasher.build(),
    ))
  let assert InvalidPasswordFormat(_) =
    should.be_error(password_hash.from_plaintext(
      "$%#^&(*!!&*^*)",
      sha256_hasher.build(),
    ))
  let assert InvalidPasswordFormat(error) =
    should.be_error(password_hash.from_plaintext("1234", sha256_hasher.build()))

  should.equal("invalid password format", error)
}

pub fn password_creation_ok_test() -> Nil {
  let assert Ok(_) =
    password_hash.from_plaintext("1Perola@", sha256_hasher.build())

  let assert Ok(_) =
    password_hash.from_plaintext("@eXcalibur12", sha256_hasher.build())

  let assert Ok(_) =
    password_hash.from_plaintext("xXx123###", sha256_hasher.build())

  Nil
}
