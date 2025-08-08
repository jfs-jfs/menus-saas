import app/di
import app/router/v1/authenticated_router
import app/router/v1/public_router
import wisp

pub fn handle_request(
  deps: di.Bag,
  path: List(String),
  request: wisp.Request,
  then: fn() -> wisp.Response,
) -> wisp.Response {
  case path {
    ["v1", ..rest] -> {
      use <- public_router.handle_request(deps, rest, request)
      use <- authenticated_router.handle_request(deps, rest, request)
      wisp.not_found()
    }
    _ -> then()
  }
}
