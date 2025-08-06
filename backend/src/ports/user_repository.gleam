import domain/auth/user
import domain/auth/value_objects/email

pub type UserRepositoryError {
  DatabaseError(message: String)
  UserExists
  UserNotFound
}

pub type UserRepository {
  UserRepository(
    save: fn(user.User) -> Result(user.User, UserRepositoryError),
    search_by_email: fn(email.Email) -> Result(user.User, UserRepositoryError),
    exists: fn(user.User) -> Result(Bool, UserRepositoryError),
  )
}
