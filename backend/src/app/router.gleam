import adapters/hasher/sha256_hasher
import adapters/http/auth/user_creation_handler
import adapters/http/middleware/logger_middleware
import adapters/http/status_handler
import adapters/sqlite/sqlite_user_repository
import ports/usecases/auth/create_user
import wisp

pub fn handle_request(request: wisp.Request) -> wisp.Response {
  use request <- logger_middleware.log_request(request)

  case wisp.path_segments(request) {
    ["status"] -> status_handler.handle(request)
    ["auth", "register"] ->
      user_creation_handler.handle(
        request,
        create_user.build(),
        sha256_hasher.build(),
        sqlite_user_repository.build(),
      )

    _ -> wisp.not_found()
  }
}
