import shared/user_identity
import wisp

pub type AuthRequest {
  AuthRequest(user_identity.UserIdentity, wisp.Request)
}

pub type HttpPublicHandler =
  fn(wisp.Request) -> wisp.Response

pub type HttpPrivateHandler =
  fn(AuthRequest) -> wisp.Response
