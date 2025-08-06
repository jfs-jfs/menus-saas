import gleam/dynamic/decode.{type Decoder}
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
