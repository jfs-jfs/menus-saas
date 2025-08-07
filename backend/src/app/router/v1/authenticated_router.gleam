import adapters/http/middleware/authentication_middleware
import adapters/jwt/jwt_token_service
import adapters/sqlite/sqlite_user_repository
import gleam/http
import ports/usecases/search_user
import wisp

pub fn handle_request(
  path: List(String),
  request: wisp.Request,
  then: fn() -> wisp.Response,
) -> wisp.Response {
  let user_repo = sqlite_user_repository.build()
  let search_user = search_user.build()
  let auth_service = jwt_token_service.build()

  let with_user = authentication_middleware.with_authenticated_user(
    request,
    auth_service,
    search_user,
    user_repo,
    _,
  )

  case request.method, path {
    http.Post, ["restaurant"] -> {
      use user <- with_user()
      // restaurant_creation_handler.handle(
      //   request,
      //   user,
      //   create_restaurant.build(),
      //   sqlite_restaurant_repository.build(),
      // ),
      todo
    }
    _, ["restaurant"] -> wisp.method_not_allowed([http.Post])

    _, _ -> then()
  }
}
