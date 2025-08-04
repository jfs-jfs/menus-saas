import gleam/http
import gleam/string_tree
import wisp

pub fn handle(request: wisp.Request) -> wisp.Response {
  use <- wisp.require_method(request, http.Get)

  let ok_response = string_tree.from_string("{\"status\": \"OK\"}")
  wisp.json_response(ok_response, 200)
}
