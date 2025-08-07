import app/router/v1/authenticated_router
import app/router/v1/public_router
import wisp

pub fn handle_request(
  path: List(String),
  request: wisp.Request,
  then: fn() -> wisp.Response,
) -> wisp.Response {
  case path {
    ["v1", ..rest] -> {
      use <- public_router.handle_request(rest, request)
      use <- authenticated_router.handle_request(rest, request)
      wisp.not_found()
    }
    _ -> then()
  }
}
