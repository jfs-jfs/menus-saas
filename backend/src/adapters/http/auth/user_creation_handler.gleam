import ports/repositories/user_repository.{type UserRepository}
import ports/services/hasher_service.{type HasherService}
import ports/usecases/auth/create_user.{
  type CreateUser, type CreateUserError, RepositoryError, UserAlreadyExists,
}
import shared/extra_result
import shared/http_codes
import shared/http_utils

import adapters/http/auth/request_decoders/user_creation_request
import gleam/http
import gleam/result
import shared/http_error.{type HttpError, HttpError} as error
import wisp.{type Request, type Response}

pub fn handle(
  request: Request,
  create_user: CreateUser,
  hasher_service: HasherService,
  user_repo: UserRepository,
) -> Response {
  use <- wisp.require_method(request, http.Post)

  use body <- http_utils.with_decoded_json_body(
    request,
    user_creation_request.decoder(hasher_service),
  )

  body
  |> create_user.execute(user_repo)
  |> translate_error()
  |> extra_result.to_nil()
  |> error.to_response()
  |> result.unwrap_error(wisp.ok())
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
