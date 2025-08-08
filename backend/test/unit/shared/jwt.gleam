import adapters/jwt/jwt_tools as jwt
import adapters/jwt/types.{JWToken}
import dot_env/env
import gleam/dict
import gleam/dynamic/decode
import gleam/json
import gleeunit/should
import gwt

pub fn jwt_encode_test() {
  let payload = json.object([#("test", json.string("hola perola"))])

  let assert Ok(JWToken(token)) = jwt.encode_jwt(payload)

  let assert Ok(loaded_token) =
    gwt.from_signed_string(token, env.get_string_or("JWT_SECRET", ""))

  let assert Ok(payload_claim) =
    loaded_token
    |> gwt.get_payload_claim(
      "payload",
      decode.dict(decode.string, decode.string),
    )

  let assert Ok(payload_value) = payload_claim |> dict.get("test")
  payload_value |> should.equal("hola perola")
}

pub fn jwt_decode_ok_test() -> Nil {
  let payload = json.object([#("test", json.string("hola perola"))])
  let assert Ok(token) = jwt.encode_jwt(payload)

  let assert Ok(payload_claim) = jwt.decode_jwt(token)

  let assert Ok(payload_value) = payload_claim |> dict.get("test")
  payload_value |> should.equal("hola perola")
}

pub fn jwt_decode_ko_invalid_string_test() -> Nil {
  let trash = JWToken("skjfhksjdghlkdsjghkdsjlfghkdlsjghsdklfghdsklgjh")
  let assert Error(error) = jwt.decode_jwt(trash)

  error |> should.equal("Invalid JWT")
}
