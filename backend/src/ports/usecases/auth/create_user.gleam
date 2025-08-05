import domain/auth/user.{type User}
import domain/auth/value_objects/email.{type Email}
import domain/auth/value_objects/password_hash.{type PasswordHash}
import ports/user_repository.{type UserRepository}

pub type CreateUser {
  CreateUser(
    execute: fn(#(Email, PasswordHash), UserRepository) -> Result(User, String),
  )
}

pub fn build() -> CreateUser {
  CreateUser(execute)
}

fn execute(
  parameters: #(Email, PasswordHash),
  user_repo: UserRepository,
) -> Result(User, String) {
  let user = user.new(parameters.0, parameters.1)
  user_repo.save(user)
}
