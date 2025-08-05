import domain/auth/value_objects/email.{type Email}
import domain/auth/value_objects/password_hash.{type PasswordHash}
import ports/services/hasher_service.{type HasherService}
import ports/usecases/auth/create_user.{type CreateUser}
import ports/user_repository.{type UserRepository}
import shared/extra_result

import gleam/dynamic/decode
import gleam/http
import gleam/result
import wisp.{type Request, type Response}

pub fn handle(
  request: Request,
  create_user: CreateUser,
  hasher_service: HasherService,
  user_repo: UserRepository,
) -> Response {
  use <- wisp.require_method(request, http.Post)
  use json <- wisp.require_json(request)

  let res =
    decode.run(json, request_decoder(hasher_service))
    |> extra_result.from_decode_result()
    |> result.map(fn(mail_and_hash) {
      create_user.execute(mail_and_hash, user_repo)
    })
    |> result.flatten()

  case res {
    Error(_) -> wisp.bad_request()
    Ok(_) -> wisp.ok()
  }
}

fn request_decoder(
  hasher_service: HasherService,
) -> decode.Decoder(#(Email, PasswordHash)) {
  use email_raw <- decode.field("email", decode.string)
  use password_raw <- decode.field("password", decode.string)
  use email <- decode.then(email.decoder(email_raw))
  use password <- decode.then(password_hash.decoder(
    password_raw,
    hasher_service,
  ))

  decode.success(#(email, password))
}
