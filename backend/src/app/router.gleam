import adapters/http/middleware/logger_middleware
import app/di
import app/router/v1/router as v1router
import wisp

pub fn handle_request(deps: di.Bag, request: wisp.Request) -> wisp.Response {
  use request <- logger_middleware.log_request(request)
  let path = request |> wisp.path_segments

  use <- handle_status_route(deps, path, request)
  use <- v1router.handle_request(deps, path, request)

  wisp.not_found()
}

fn handle_status_route(
  deps: di.Bag,
  path: List(String),
  request: wisp.Request,
  then: fn() -> wisp.Response,
) -> wisp.Response {
  case path {
    ["status"] -> deps.http_handlers.status(request)
    _ -> then()
  }
}
