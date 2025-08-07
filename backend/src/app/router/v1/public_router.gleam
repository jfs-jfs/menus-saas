import adapters/hasher/sha256_hasher
import adapters/http/auth/user_creation_handler
import adapters/http/auth/user_login_handler
import adapters/jwt/jwt_token_service
import adapters/sqlite/sqlite_user_repository
import ports/usecases/auth/authenticate_user
import ports/usecases/auth/create_user
import wisp

pub fn handle_request(
  path: List(String),
  request: wisp.Request,
  then: fn() -> wisp.Response,
) -> wisp.Response {
  case path {
    ["auth", "signup"] ->
      user_creation_handler.handle(
        request,
        create_user.build(),
        sha256_hasher.build(),
        sqlite_user_repository.build(),
      )
    ["auth", "login"] ->
      user_login_handler.handle(
        request,
        sha256_hasher.build(),
        sqlite_user_repository.build(),
        jwt_token_service.build(),
        authenticate_user.build(),
      )
    _ -> then()
  }
}
