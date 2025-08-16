import domain/auth/user.{type User}
import domain/auth/value_objects/email.{type Email}
import domain/auth/value_objects/user_id.{type UserId}
import gleam/option.{type Option, None, Some}
import gleam/result
import ports/repositories/user_repository.{
  type UserRepository, type UserRepositoryError, DatabaseError,
}
import shared/state

pub type SearchUserRequest =
  #(Option(UserId), Option(Email))

pub type SearchUserError {
  MissingSearchParameter
  RepositoryError
  UserNotFound
}

pub type SearchUser {
  SearchUser(execute: fn(SearchUserRequest) -> Result(User, SearchUserError))
}

pub fn build(repo: UserRepository) -> SearchUser {
  SearchUser(execute: execute(_, repo))
}

fn execute(
  params: SearchUserRequest,
  user_repo: UserRepository,
) -> Result(User, SearchUserError) {
  case params {
    #(Some(id), _) ->
      id
      |> user_repo.search_by_id()
      |> translate_error()

    #(_, Some(email)) ->
      email
      |> user_repo.search_by_email()
      |> translate_error()

    #(None, None) -> Error(MissingSearchParameter)
  }
}

fn translate_error(
  res: Result(a, UserRepositoryError),
) -> Result(a, SearchUserError) {
  use error <- result.map_error(res)
  case error {
    DatabaseError(_) -> RepositoryError
    user_repository.UserNotFound -> UserNotFound
    user_repository.UserExists ->
      state.impossible_state_reached(
        "SearchUser->translate_error",
        "usecase search user should not receive this error ever (UserExists) ",
      )
  }
}
