import gleam/dynamic/decode.{type Decoder}
import gleam/json.{type Json}
import gleam/result
import shared/http_error as error
import wisp.{type Request, type Response}

pub fn with_decoded_json_body(
  request: Request,
  decoder: Decoder(a),
  then: fn(a) -> Response,
) -> Response {
  use json <- wisp.require_json(request)
  let something =
    decode.run(json, decoder)
    |> error.from_decode()
    |> error.to_response()

  case something {
    Error(err_response) -> err_response
    Ok(value) -> then(value)
  }
}

pub fn json_response(status: Int, body: Json) -> Response {
  body |> json.to_string_tree() |> wisp.json_response(status)
}

pub fn map_json_response(
  res: Result(Json, b),
  status: Int,
) -> Result(Response, b) {
  use json <- result.map(res)
  status |> json_response(json)
}
