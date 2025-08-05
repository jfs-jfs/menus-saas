import domain/auth/user
import domain/auth/value_objects/email
import gleam/option

pub type UserRepository {
  UserRepository(
    save: fn(user.User) -> Result(user.User, String),
    search_by_email: fn(email.Email) -> Result(option.Option(user.User), String),
    exists: fn(user.User) -> Result(Bool, String),
  )
}
