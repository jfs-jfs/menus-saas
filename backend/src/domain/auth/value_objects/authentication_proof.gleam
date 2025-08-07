import domain/auth/types.{type AuthenticationToken, type DecodedClaims}
import ports/services/authentication_service.{
  type AuthenticationService, UnkownToken as UnknownToken,
}
import shared/state

pub type AuthenticationProofError {
  InvalidAuthToken(token: AuthenticationToken)
}

pub type AuthenticationProof {
  AuthenticationProof(claims: DecodedClaims)
}

pub fn create(
  token: AuthenticationToken,
  auth_service: AuthenticationService,
) -> Result(AuthenticationProof, AuthenticationProofError) {
  case auth_service.validate(token) {
    Ok(claims) -> Ok(AuthenticationProof(claims:))
    Error(UnknownToken(token)) -> Error(InvalidAuthToken(token))
    _ ->
      state.impossible_state_reached(
        "AuthProof->create",
        "impossible error from auth_service received",
      )
  }
}
