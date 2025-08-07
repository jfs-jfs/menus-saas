import adapters/jwt/jwt_token
import domain/auth/types.{type DecodedClaims}
import domain/auth/user
import gleam/json
import gleam/option
import gleam/result
import ports/services/authentication_service.{
  type AuthenticationService, type AuthenticationServiceError,
  AuthenticationService, NonPersistentUser, ServiceError,
}
import shared/jwt

pub fn build() -> AuthenticationService {
  AuthenticationService(generate:, validate:)
}

fn validate(
  token: types.AuthenticationToken,
) -> Result(DecodedClaims, AuthenticationServiceError) {
  token
  |> jwt_token.JWToken()
  |> jwt.decode_jwt()
  |> result.map_error(fn(_) { authentication_service.UnkownToken(token) })
}

fn generate(
  user: user.User,
) -> Result(types.AuthenticationToken, AuthenticationServiceError) {
  case user.id {
    option.None -> Error(NonPersistentUser)
    option.Some(_) ->
      json.object([#("email", json.string(user.email.value))])
      |> jwt.encode_jwt()
      |> result.map_error(fn(err) { ServiceError(err) })
      |> result.map(fn(token) { token.value })
  }
}
