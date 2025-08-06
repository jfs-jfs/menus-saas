import adapters/sqlite/database
import domain/auth/user.{type User}
import domain/auth/value_objects/email.{InvalidFormat}
import domain/auth/value_objects/password_hash
import gleam/dynamic/decode
import gleam/list
import gleam/option
import gleam/result
import ports/user_repository.{
  type UserRepository, type UserRepositoryError, DatabaseError, UserExists,
  UserNotFound, UserRepository,
}
import sqlight

pub fn build() -> UserRepository {
  UserRepository(save: save, search_by_email: search_by_email, exists: exists)
}

fn save(user: User) -> Result(User, UserRepositoryError) {
  case user.id {
    option.None -> create(user)
    option.Some(_) -> update(user)
  }
}

fn create(user: User) -> Result(User, UserRepositoryError) {
  use connection <- result.try(database.open_ok() |> translate_error())

  let res =
    sqlight.query(
      "INSERT INTO users (email, hash) VALUES (?, ?)",
      connection,
      [sqlight.text(user.email.value), sqlight.text(user.password_hash.value)],
      decode.dynamic,
    )
    |> translate_error()
    |> result.map(fn(_) { Nil })

  use _ <- result.try(database.close_ok(connection) |> translate_error())
  use _ <- result.try(res)

  search_by_email(user.email)
}

fn update(user: User) -> Result(User, UserRepositoryError) {
  use connection <- result.try(database.open_ok() |> translate_error())

  let res =
    sqlight.query(
      "UPDATE users set email = ?, hash = ? WHERE ",
      connection,
      [sqlight.text(user.email.value), sqlight.text(user.password_hash.value)],
      decode.dynamic,
    )
    |> translate_error()
    |> result.map(fn(_) { user })

  use _ <- result.try(database.close_ok(connection) |> translate_error())
  res
}

fn search_by_email(email: email.Email) -> Result(user.User, UserRepositoryError) {
  use connection <- result.try(database.open_ok() |> translate_error())

  let user_decoder = user_decoder()

  let res =
    sqlight.query(
      "SELECT id, email, hash FROM users WHERE email = ? LIMIT 1",
      connection,
      [sqlight.text(email.value)],
      user_decoder,
    )

  use _ <- result.try(database.close_ok(connection) |> translate_error())

  res
  |> translate_error()
  |> result.map(fn(users) {
    list.first(users)
    |> result.map_error(fn(_) { UserNotFound })
  })
  |> result.flatten()
}

fn exists(user: User) -> Result(Bool, UserRepositoryError) {
  case search_by_email(user.email) {
    Ok(_) -> Ok(True)
    Error(UserNotFound) -> Ok(False)
    Error(x) -> Error(x)
  }
}

fn user_decoder() -> decode.Decoder(user.User) {
  use id <- decode.field(0, decode.int)
  use email_str <- decode.field(1, decode.string)
  use hash_str <- decode.field(2, decode.string)

  let decoder_email = case email.create(email_str) {
    Error(InvalidFormat(error)) -> decode.failure(email.Email(""), error)
    Ok(value) -> decode.success(value)
  }

  let decoder_hash = case password_hash.create(hash_str) {
    Error(_) ->
      decode.failure(
        password_hash.PasswordHash(""),
        "Invalid hash in database from user -> " <> email_str,
      )
    Ok(value) -> decode.success(value)
  }

  use email <- decode.then(decoder_email)
  use hash <- decode.then(decoder_hash)

  decode.success(user.load(id, email, hash))
}

fn translate_error(
  res: Result(a, sqlight.Error),
) -> Result(a, UserRepositoryError) {
  use sql_error <- result.map_error(res)

  let sqlight.SqlightError(code, message, _) = sql_error
  case code {
    sqlight.ConstraintUnique -> UserExists
    _ -> DatabaseError(message:)
  }
}
