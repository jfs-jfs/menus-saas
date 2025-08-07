import adapters/http/middleware/logger_middleware
import adapters/http/status_handler
import app/router/v1/router as v1router
import wisp

pub fn handle_request(request: wisp.Request) -> wisp.Response {
  use request <- logger_middleware.log_request(request)
  let path = request |> wisp.path_segments

  use <- handle_status_route(path, request)
  use <- v1router.handle_request(path, request)

  wisp.not_found()
}

fn handle_status_route(
  path: List(String),
  request: wisp.Request,
  then: fn() -> wisp.Response,
) -> wisp.Response {
  case path {
    ["status"] -> status_handler.handle(request)
    _ -> then()
  }
}
