import adapters/http/common/http_codes
import adapters/http/common/http_error.{type HttpError, HttpError}
import adapters/http/types.{type AuthRequest, AuthRequest}
import domain/auth/user
import gleam/http
import gleam/json
import gleam/option.{None, Some}
import gleam/result
import ports/usecases/auth/search_user.{type SearchUser, type SearchUserError}
import shared/state
import shared/user_identity
import wisp.{type Response}

pub fn handle(auth_request: AuthRequest, searcher: SearchUser) -> Response {
  let AuthRequest(identifier, request) = auth_request
  use <- wisp.require_method(request, http.Get)

  let user_id = identifier |> user_identity.to_user()

  let user_or_error =
    #(Some(user_id), None)
    |> searcher.execute()
    |> translate_error()
    |> http_error.to_response()

  case user_or_error {
    Error(err_response) -> err_response
    Ok(user) ->
      user
      |> user.to_json()
      |> json.to_string_tree()
      |> wisp.json_response(http_codes.ok)
  }
}

fn translate_error(res: Result(a, SearchUserError)) -> Result(a, HttpError) {
  use error <- result.map_error(res)
  case error {
    search_user.RepositoryError ->
      HttpError(http_codes.internal_server_error, "try again alter")
    search_user.UserNotFound -> HttpError(http_codes.not_found, "")
    search_user.MissingSearchParameter ->
      state.impossible_state_reached(
        "user info handler -> translate error",
        "criteria should always be set as it comes from the request authentication",
      )
  }
}
