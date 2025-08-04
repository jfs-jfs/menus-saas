import dot_env/env
import gleam/dict
import gleam/dynamic/decode
import gleam/float
import gleam/json
import gleam/result
import gleam/time/duration
import gleam/time/timestamp
import gwt

pub const payload_key = "payload"

pub fn encode_jwt(payload: json.Json) -> Result(String, String) {
  use secret <- result.try(env.get_string("JWT_SECRET"))
  use duration <- result.try(env.get_int("JWT_DURATION_HOURS"))

  let issued_at = timestamp.system_time()
  let expires_at =
    issued_at
    |> timestamp.add(duration.hours(duration))
    |> timestamp.to_unix_seconds()
    |> float.truncate()

  let issued_at =
    issued_at
    |> timestamp.to_unix_seconds()
    |> float.truncate()

  let token =
    gwt.new()
    |> gwt.set_issued_at(issued_at)
    |> gwt.set_expiration(expires_at)
    |> gwt.set_payload_claim(payload_key, payload)
    |> gwt.to_signed_string(gwt.HS256, secret)

  Ok(token)
}

pub fn decode_jwt(
  maybe_jwt: String,
) -> Result(dict.Dict(String, String), String) {
  use secret <- result.try(env.get_string("JWT_SECRET"))

  let to_extract_payload = fn(token) {
    token
    |> gwt.get_payload_claim(
      payload_key,
      decode.dict(decode.string, decode.string),
    )
  }

  gwt.from_signed_string(maybe_jwt, secret)
  |> result.try(to_extract_payload)
  |> result.map_error(fn(_) { "Invalid JWT" })
}
