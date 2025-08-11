import adapters/http/common/http_codes
import ports/services/hasher_service.{type HasherService}
import ports/usecases/auth/create_user.{
  type CreateUser, type CreateUserError, RepositoryError, UserAlreadyExists,
}

import adapters/http/auth/request_decoders/user_creation_request
import adapters/http/common/handler_tools
import adapters/http/common/http_error.{type HttpError, HttpError} as error
import gleam/http
import gleam/result
import wisp.{type Request, type Response}

pub fn handle(
  request: Request,
  create_user: CreateUser,
  hasher_service: HasherService,
) -> Response {
  use <- wisp.require_method(request, http.Post)

  use body <- handler_tools.with_decoded_json_body(
    request,
    user_creation_request.decoder(hasher_service),
  )

  body
  |> create_user.execute()
  |> translate_error()
  |> error.to_response()
  |> result.unwrap_error(wisp.no_content())
}

fn translate_error(res: Result(a, CreateUserError)) -> Result(a, HttpError) {
  use error <- result.map_error(res)

  case error {
    RepositoryError ->
      HttpError(http_codes.internal_server_error, "try again later")
    UserAlreadyExists ->
      HttpError(http_codes.conflict, "email is already registered")
  }
}
