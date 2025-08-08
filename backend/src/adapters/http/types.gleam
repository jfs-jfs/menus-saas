import domain/auth/user
import wisp

pub type AuthRequest =
  #(user.User, wisp.Request)

pub type HttpPublicHandler =
  fn(wisp.Request) -> wisp.Response

pub type HttpPrivateHandler =
  fn(AuthRequest) -> wisp.Response
