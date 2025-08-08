import adapters/http/middleware/authentication_middleware
import adapters/http/types.{AuthRequest}
import gleam/http
import wisp

import app/di

pub fn handle_request(
  deps: di.Bag,
  path: List(String),
  request: wisp.Request,
  then: fn() -> wisp.Response,
) -> wisp.Response {
  let with_user = authentication_middleware.with_authenticated_user(
    request,
    deps.services.auth,
    deps.usecases.search_user,
    _,
  )

  case request.method, path {
    http.Post, ["restaurant"] -> {
      use user <- with_user()
      deps.http_handlers.restaurant_creation(AuthRequest(user, request))
    }
    _, ["restaurant"] -> wisp.method_not_allowed([http.Post])

    _, _ -> then()
  }
}
