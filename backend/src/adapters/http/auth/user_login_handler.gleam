import adapters/http/auth/request_decoders/user_login_request
import gleam/http
import gleam/json
import gleam/result
import ports/services/hasher_service.{type HasherService}
import ports/usecases/auth/authenticate_user.{
  type AuthenticateUser, type AuthenticateUserError, AuthenticationServiceError,
  RepositoryError, UnableToAuthenticate,
}
import shared/http_codes
import shared/http_error.{type HttpError, HttpError}
import shared/http_utils
import wisp.{type Request, type Response}

pub fn handle(
  request: Request,
  hasher: HasherService,
  authenticate_user: AuthenticateUser,
) -> Response {
  use <- wisp.require_method(request, http.Post)
  use body <- http_utils.with_decoded_json_body(
    request,
    user_login_request.decoder(hasher),
  )

  body
  |> authenticate_user.execute()
  |> translate_error()
  |> http_error.to_response()
  |> result.map(fn(token) { json.object([#("token", json.string(token))]) })
  |> http_utils.map_json_response(http_codes.ok)
  |> result.unwrap_both()
}

pub fn translate_error(
  res: Result(a, AuthenticateUserError),
) -> Result(a, HttpError) {
  use error <- result.map_error(res)
  case error {
    RepositoryError | AuthenticationServiceError ->
      HttpError(http_codes.internal_server_error, "try again later")
    UnableToAuthenticate(reason) -> HttpError(http_codes.unauthorized, reason)
  }
}
