import adapters/http/common/http_codes
import gleam/dynamic/decode
import gleam/json
import gleam/result
import gleam/string
import shared/extra_result
import wisp

pub type HttpError {
  HttpError(code: Int, message: String)
}

pub fn from_decode(
  res: Result(a, List(decode.DecodeError)),
) -> Result(a, HttpError) {
  res
  |> extra_result.from_decode_result()
  |> result.map_error(fn(msg) { HttpError(http_codes.bad_request, msg) })
}

pub fn to_response(res: Result(a, HttpError)) -> Result(a, wisp.Response) {
  use HttpError(code, message) <- result.map_error(res)
  wisp.json_response(
    json.to_string_tree(
      json.object([
        #("errors", json.array(message |> string.split("\n"), json.string)),
      ]),
    ),
    code,
  )
}
