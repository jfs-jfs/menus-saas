import domain/auth/user
import domain/auth/value_objects/email.{type Email}
import domain/auth/value_objects/password_hash.{type PasswordHash}
import gleam/result
import gleam/string
import ports/repositories/user_repository.{
  type UserRepository, type UserRepositoryError, DatabaseError, UserExists,
  UserNotFound,
}
import ports/services/authentication_service.{
  type AuthenticationService, type AuthenticationServiceError, NonPersistentUser,
  ServiceError,
}
import shared/state
import wisp

pub type AuthenticateUserError {
  RepositoryError
  AuthenticationServiceError
  UnableToAuthenticate(reason: String)
}

pub type AuthenticateUser {
  AuthenticateUser(
    execute: fn(#(Email, PasswordHash), UserRepository, AuthenticationService) ->
      Result(String, AuthenticateUserError),
  )
}

pub fn build() -> AuthenticateUser {
  AuthenticateUser(execute)
}

fn execute(
  params: #(Email, PasswordHash),
  user_repo: UserRepository,
  token_service: AuthenticationService,
) -> Result(String, AuthenticateUserError) {
  use user <- result.try(
    user_repo.search_by_email(params.0) |> translate_error_repo(),
  )

  case user.can_authenticate(user, params.1) {
    False -> Error(UnableToAuthenticate("invalid credentials"))
    True -> token_service.generate(user) |> translate_error_service()
  }
}

fn translate_error_repo(
  res: Result(a, UserRepositoryError),
) -> Result(a, AuthenticateUserError) {
  use error <- result.map_error(res)
  case error {
    DatabaseError(_) -> RepositoryError
    UserNotFound -> UnableToAuthenticate("invalid credentials")
    UserExists ->
      state.impossible_state_reached(
        "AuthUser->translate_error_repo",
        "usecase authenticate_user should not recieve UserExists ever",
      )
  }
}

fn translate_error_service(
  res: Result(a, AuthenticationServiceError),
) -> Result(a, AuthenticateUserError) {
  use error <- result.map_error(res)
  case error {
    NonPersistentUser -> UnableToAuthenticate("invalid credentials")
    ServiceError(_) -> AuthenticationServiceError
    impossible_errors ->
      state.impossible_state_reached(
        "AuthUser->translate_error_repo",
        "usecase authenticate user should not recieve this errors ever :"
          <> impossible_errors |> string.inspect(),
      )
  }
}
