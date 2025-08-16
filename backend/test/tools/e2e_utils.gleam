import app/router
import dot_env/env
import gleam/bit_array
import gleam/bytes_tree
import gleam/dynamic/decode
import gleam/http/request
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/string_tree
import tools/dependencies
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

pub fn get_authenticated_json(
  user: #(String, String),
  endpoint: String,
  headers: List(#(String, String)),
  then: fn(wisp.Response) -> Nil,
) -> Nil {
  let #(email, password) = user
  let request = "
  {
    \"email\": \"" <> email <> "\",
    \"password\": \"" <> password <> "\"
  }
  "

  use response <- post_json("/v1/auth/login", [], request)
  let answer_body = extract_body(response)

  let body_decode = {
    use token <- decode.field("token", decode.string)
    decode.success(token)
  }

  let assert Ok(token) = json.parse(answer_body, body_decode)

  get_json(
    endpoint,
    headers
      |> list.append([
        #(env.get_string_or("JWT_HEADER", "authentication"), token),
      ]),
    then,
  )
}

pub fn post_authenticated_json(
  user: #(String, String),
  endpoint: String,
  headers: List(#(String, String)),
  body: String,
  then: fn(wisp.Response) -> Nil,
) -> Nil {
  let #(email, password) = user
  let request = "
  {
    \"email\": \"" <> email <> "\",
    \"password\": \"" <> password <> "\"
  }
  "

  use response <- post_json("/v1/auth/login", [], request)
  let answer_body = extract_body(response)

  let body_decode = {
    use token <- decode.field("token", decode.string)
    decode.success(token)
  }

  let assert Ok(token) = json.parse(answer_body, body_decode)

  post_json(
    endpoint,
    headers
      |> list.append([
        #(env.get_string_or("JWT_HEADER", "authentication"), token),
      ]),
    body,
    then,
  )
}

pub fn put_authenticated_json(
  user: #(String, String),
  endpoint: String,
  headers: List(#(String, String)),
  body: String,
  then: fn(wisp.Response) -> Nil,
) -> Nil {
  let #(email, password) = user
  let request = "
  {
    \"email\": \"" <> email <> "\",
    \"password\": \"" <> password <> "\"
  }
  "

  use response <- post_json("/v1/auth/login", [], request)
  let answer_body = extract_body(response)

  let body_decode = {
    use token <- decode.field("token", decode.string)
    decode.success(token)
  }

  let assert Ok(token) = json.parse(answer_body, body_decode)

  put_json(
    endpoint,
    headers
      |> list.append([
        #(env.get_string_or("JWT_HEADER", "authentication"), token),
      ]),
    body,
    then,
  )
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

  let deps = dependencies.build_test_di()
  router.handle_request(deps, req) |> then()
}

pub fn get_json(
  endpoint: String,
  headers: List(#(String, String)),
  then: fn(wisp.Response) -> Nil,
) -> Nil {
  let req =
    testing.get(endpoint, headers)
    |> request.set_header("content-type", "application/json")

  let deps = dependencies.build_test_di()
  router.handle_request(deps, req) |> then()
}

pub fn put_json(
  endpoint: String,
  headers: List(#(String, String)),
  body: String,
  then: fn(wisp.Response) -> Nil,
) -> Nil {
  let req =
    testing.put(endpoint, headers, body)
    |> request.set_header("content-type", "application/json")

  let deps = dependencies.build_test_di()
  router.handle_request(deps, req) |> then()
}

pub fn patch_json(
  endpoint: String,
  headers: List(#(String, String)),
  body: String,
  then: fn(wisp.Response) -> Nil,
) -> Nil {
  let req =
    testing.patch(endpoint, headers, body)
    |> request.set_header("content-type", "application/json")

  let deps = dependencies.build_test_di()
  router.handle_request(deps, req) |> then()
}

pub fn delete_json(
  endpoint: String,
  headers: List(#(String, String)),
  body: String,
  then: fn(wisp.Response) -> Nil,
) -> Nil {
  let req =
    testing.delete(endpoint, headers, body)
    |> request.set_header("content-type", "application/json")

  let deps = dependencies.build_test_di()
  router.handle_request(deps, req) |> then()
}
