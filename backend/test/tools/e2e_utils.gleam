import app/router
import gleam/bit_array
import gleam/bytes_tree
import gleam/http/request
import gleam/int
import gleam/io
import gleam/list
import gleam/string_tree
import wisp
import wisp/testing

pub fn extract_body(res: wisp.Response) -> String {
  case res.body {
    wisp.Bytes(bytes) ->
      bytes |> bytes_tree.to_bit_array() |> bit_array.base16_encode()
    wisp.Empty -> "[]"
    wisp.File(path) -> path
    wisp.Text(tree) -> tree |> string_tree.to_string()
  }
}

pub fn extract_status_code(res: wisp.Response) -> Int {
  res.status
}

pub fn extract_headers(res: wisp.Response) -> List(String) {
  res.headers
  |> list.map(fn(pair) { pair.0 <> ": " <> pair.1 })
}

pub fn print_response(res: wisp.Response) -> Nil {
  io.println("Response [")
  io.println("  status -> " <> extract_status_code(res) |> int.to_string())
  io.println("  headers -> [")

  extract_headers(res)
  |> list.map(fn(header) { io.println("    " <> header) })

  io.println("  ]")
  io.println("  body -> " <> extract_body(res))
  io.println("]")
}

pub fn post_json(
  endpoint: String,
  headers: List(#(String, String)),
  body: String,
  then: fn(wisp.Response) -> Nil,
) -> Nil {
  let req =
    testing.post(endpoint, headers, body)
    |> request.set_header("content-type", "application/json")

  router.handle_request(req) |> then()
}
