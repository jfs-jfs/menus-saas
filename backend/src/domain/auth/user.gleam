import domain/auth/value_objects/email.{type Email}
import domain/auth/value_objects/password_hash.{type PasswordHash}
import domain/auth/value_objects/user_id.{type UserId}
import gleam/option.{type Option, None, Some}

pub type User {
  User(id: Option(UserId), email: Email, password_hash: PasswordHash)
}

pub fn load(id: UserId, email: Email, password_hash: PasswordHash) -> User {
  User(Some(id), email, password_hash)
}

pub fn new(email: Email, password_hash: PasswordHash) -> User {
  User(None, email, password_hash)
}

pub fn can_authenticate(user: User, with: PasswordHash) -> Bool {
  user.password_hash |> password_hash.is_equal(with)
}
