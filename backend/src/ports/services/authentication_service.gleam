import domain/auth/user.{type User}

pub type AuthenticationServiceError {
  NonPersistentUser
  ServiceError(cause: String)
}

pub type AuthenticationService {
  AuthenticationService(
    generate: fn(User) -> Result(String, AuthenticationServiceError),
  )
}
