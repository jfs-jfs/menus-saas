import dot_env/env
import gleam/dict
import gleam/dynamic/decode
import gleam/json
import gwt
import shared/jwt

pub fn jwt_encode_test() {
  let payload = json.object([#("test", json.string("hola perola"))])

  let assert Ok(token) = jwt.encode_jwt(payload)

  let assert Ok(loaded_token) =
    gwt.from_signed_string(token, env.get_string_or("JWT_SECRET", ""))

  let assert Ok(payload_claim) =
    loaded_token
    |> gwt.get_payload_claim(
      "payload",
      decode.dict(decode.string, decode.string),
    )

  let assert Ok(payload_value) = payload_claim |> dict.get("test")
  assert payload_value == "hola perola"
}

pub fn jwt_decode_ok_test() -> Nil {
  let payload = json.object([#("test", json.string("hola perola"))])
  let assert Ok(token) = jwt.encode_jwt(payload)

  let assert Ok(payload_claim) = jwt.decode_jwt(token)

  let assert Ok(payload_value) = payload_claim |> dict.get("test")
  assert payload_value == "hola perola"
}

pub fn jwt_decode_ko_invalid_string_test() -> Nil {
  let trash = "skjfhksjdghlkdsjghkdsjlfghkdlsjghsdklfghdsklgjh"
  let assert Error(error) = jwt.decode_jwt(trash)

  assert error == "Invalid JWT" as "Bad error message"
}
