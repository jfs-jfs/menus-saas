import app/di
import wisp

pub fn handle_request(
  deps: di.Bag,
  path: List(String),
  request: wisp.Request,
  then: fn() -> wisp.Response,
) -> wisp.Response {
  case path {
    ["auth", "signup"] -> deps.http_handlers.auth_signup(request)
    ["auth", "login"] -> deps.http_handlers.auth_login(request)
    _ -> then()
  }
}
