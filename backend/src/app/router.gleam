import adapters/http/middleware/logger_middleware
import adapters/http/status_handler
import wisp

pub fn handle_request(request: wisp.Request) -> wisp.Response {
  use request <- logger_middleware.log_request(request)

  case wisp.path_segments(request) {
    ["status"] -> status_handler.handle(request)

    _ -> wisp.not_found()
  }
}
