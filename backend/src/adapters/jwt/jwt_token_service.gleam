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
  AuthenticationService(generate)
}

fn generate(user: user.User) -> Result(String, AuthenticationServiceError) {
  case user.id {
    option.None -> Error(NonPersistentUser)
    option.Some(_) ->
      json.object([#("email", json.string(user.email.value))])
      |> jwt.encode_jwt()
      |> result.map_error(fn(err) { ServiceError(err) })
      |> result.map(fn(token) { token.value })
  }
}
