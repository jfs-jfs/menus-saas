import adapters/sqlite/database
import domain/auth/user.{type User}
import domain/auth/value_objects/email
import domain/auth/value_objects/password_hash
import domain/auth/value_objects/user_id
import gleam/dynamic/decode
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import ports/repositories/user_repository.{
  type UserRepository, type UserRepositoryError, DatabaseError, UserExists,
  UserNotFound, UserRepository,
}
import sqlight

pub fn build() -> UserRepository {
  UserRepository(
    save: save,
    search_by_id: search_by_id,
    search_by_email: search_by_email,
    exists: exists,
  )
}

fn save(user: User) -> Result(User, UserRepositoryError) {
  case user.id {
    None -> create(user)
    Some(_) -> update(user)
  }
}

fn create(user: User) -> Result(User, UserRepositoryError) {
  use connection <- result.try(database.open() |> translate_error())

  let res =
    sqlight.query(
      "INSERT INTO users (email, hash) VALUES (?, ?)",
      connection,
      [sqlight.text(user.email.value), sqlight.text(user.password_hash.value)],
      decode.dynamic,
    )
    |> translate_error()
    |> result.map(fn(_) { Nil })

  use _ <- result.try(database.close(connection) |> translate_error())
  use _ <- result.try(res)

  search_by_email(user.email)
}

fn update(user: User) -> Result(User, UserRepositoryError) {
  use connection <- result.try(database.open() |> translate_error())

  let res =
    sqlight.query(
      "UPDATE users set email = ?, hash = ? WHERE ",
      connection,
      [sqlight.text(user.email.value), sqlight.text(user.password_hash.value)],
      decode.dynamic,
    )
    |> translate_error()
    |> result.map(fn(_) { user })

  use _ <- result.try(database.close(connection) |> translate_error())
  res
}

fn search_by_id(id: user_id.UserId) -> Result(User, UserRepositoryError) {
  use connection <- result.try(database.open() |> translate_error())

  let res =
    sqlight.query(
      "SELECT id, email, hash FROM users WHERE id = ? LIMIT 1",
      connection,
      [sqlight.int(id |> user_id.value())],
      user_decoder(),
    )

  use _ <- result.try(database.close(connection) |> translate_error())

  res
  |> translate_error()
  |> result.map(fn(users) {
    users
    |> list.first()
    |> result.map_error(fn(_) { UserNotFound })
  })
  |> result.flatten()
}

fn search_by_email(email: email.Email) -> Result(user.User, UserRepositoryError) {
  use connection <- result.try(database.open() |> translate_error())

  let user_decoder = user_decoder()

  let res =
    sqlight.query(
      "SELECT id, email, hash FROM users WHERE email = ? LIMIT 1",
      connection,
      [sqlight.text(email.value)],
      user_decoder,
    )

  use _ <- result.try(database.close(connection) |> translate_error())

  res
  |> translate_error()
  |> result.map(fn(users) {
    list.first(users)
    |> result.map_error(fn(_) { UserNotFound })
  })
  |> result.flatten()
}

fn exists(user: User) -> Result(Bool, UserRepositoryError) {
  let filter_search_errors = fn(res: Result(user, UserRepositoryError)) {
    case res {
      Error(UserNotFound) -> Ok(True)
      Ok(_) -> Ok(True)
      Error(x) -> Error(x)
    }
  }

  case user.id {
    None -> Ok(False)
    Some(id) ->
      id
      |> search_by_id()
      |> filter_search_errors()
  }
}

fn user_decoder() -> decode.Decoder(user.User) {
  use id_int <- decode.field(0, decode.int)
  use id <- decode.then(user_id.decoder(id_int))

  use email_str <- decode.field(1, decode.string)
  use email <- decode.then(email.decoder(email_str))

  use hash_str <- decode.field(2, decode.string)
  use hash <- decode.then(password_hash.decoder_hash(hash_str))

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
