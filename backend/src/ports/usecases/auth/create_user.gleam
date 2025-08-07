import domain/auth/user.{type User}
import domain/auth/value_objects/email.{type Email}
import domain/auth/value_objects/password_hash.{type PasswordHash}
import gleam/result
import ports/repositories/user_repository.{
  type UserRepository, type UserRepositoryError, DatabaseError, UserExists,
  UserNotFound,
}
import shared/state

pub type CreateUserError {
  UserAlreadyExists
  RepositoryError
}

pub type CreateUser {
  CreateUser(
    execute: fn(#(Email, PasswordHash), UserRepository) ->
      Result(User, CreateUserError),
  )
}

pub fn build() -> CreateUser {
  CreateUser(execute)
}

fn execute(
  parameters: #(Email, PasswordHash),
  user_repo: UserRepository,
) -> Result(User, CreateUserError) {
  let user = user.new(parameters.0, parameters.1)
  user_repo.save(user) |> translate_error()
}

fn translate_error(
  res: Result(a, UserRepositoryError),
) -> Result(a, CreateUserError) {
  use error <- result.map_error(res)
  case error {
    UserExists -> UserAlreadyExists
    DatabaseError(_) -> RepositoryError
    UserNotFound ->
      state.impossible_state_reached(
        "CreateUser->translate_error",
        "usecase create_user should not recieve UserNotFound ever",
      )
  }
}
