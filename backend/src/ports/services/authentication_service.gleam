import domain/auth/types.{type AuthenticationToken, type DecodedClaims}
import domain/auth/user.{type User}

pub type AuthenticationServiceError {
  NonPersistentUser
  ServiceError(cause: String)
  UnkownToken(token: AuthenticationToken)
}

pub type AuthenticationService {
  AuthenticationService(
    generate: fn(User) ->
      Result(AuthenticationToken, AuthenticationServiceError),
    validate: fn(AuthenticationToken) ->
      Result(DecodedClaims, AuthenticationServiceError),
  )
}
