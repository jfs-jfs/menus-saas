import domain/auth/types.{type DecodedClaims}
import domain/auth/user
import domain/auth/value_objects/authentication_proof.{
  type AuthenticationProof, AuthenticationProof,
}
import domain/auth/value_objects/email
import dot_env/env
import gleam/dict
import gleam/http/request
import gleam/option.{None, Some}
import gleam/result
import ports/services/authentication_service.{type AuthenticationService}
import ports/usecases/auth/search_user.{type SearchUserRequest}
import shared/extra_result
import shared/http_codes
import wisp

fn filter_unauthenticated(
  request: wisp.Request,
  auth_service: AuthenticationService,
  then: fn(AuthenticationProof) -> wisp.Response,
) -> wisp.Response {
  let token_header = env.get_string_or("JWT_HEADER", "Authentication")

  let proof_or_error =
    request
    |> request.get_header(token_header)
    |> result.map(fn(token) {
      auth_service.validate(token) |> extra_result.clear_error()
    })
    |> result.flatten()
    |> result.map(AuthenticationProof)

  case proof_or_error {
    Error(_) -> http_codes.unauthorized |> wisp.response()
    Ok(proof) -> then(proof)
  }
}

fn with_parsed_claims(
  claims: DecodedClaims,
  then: fn(email.Email) -> wisp.Response,
) -> wisp.Response {
  claims
  |> dict.get("email")
  |> result.map(email.create)
  |> result.map(extra_result.clear_error)
  |> result.flatten()
  |> result.map(then)
  |> result.map_error(fn(_) { wisp.response(http_codes.unauthorized) })
  |> result.unwrap_both()
}

pub fn with_authenticated_user(
  request: wisp.Request,
  auth_service: authentication_service.AuthenticationService,
  searcher: search_user.SearchUser,
  on_authenticated: fn(user.User) -> wisp.Response,
) -> wisp.Response {
  use AuthenticationProof(claims) <- filter_unauthenticated(
    request,
    auth_service,
  )
  use email <- with_parsed_claims(claims)

  let search_request: SearchUserRequest = #(None, Some(email))

  case searcher.execute(search_request) {
    Ok(user) -> on_authenticated(user)
    Error(_) -> http_codes.unauthorized |> wisp.response()
  }
}
