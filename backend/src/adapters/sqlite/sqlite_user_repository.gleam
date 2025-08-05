import adapters/sqlite/database
import domain/auth/user.{type User}
import domain/auth/value_objects/email
import domain/auth/value_objects/password_hash
import gleam/dynamic/decode
import gleam/list
import gleam/option.{type Option}
import gleam/result
import ports/user_repository.{type UserRepository, UserRepository}
import sqlight

pub fn build() -> UserRepository {
  UserRepository(save: save, search_by_email: search_by_email, exists: exists)
}

fn save(user: User) -> Result(User, String) {
  case user.id {
    option.None -> create(user)
    option.Some(_) -> update(user)
  }
}

fn create(user: User) -> Result(User, String) {
  use connection <- result.try(database.open())

  let res =
    sqlight.query(
      "INSERT INTO users (email, hash) VALUES (?, ?)",
      connection,
      [sqlight.text(user.email.value), sqlight.text(user.password_hash.value)],
      decode.dynamic,
    )
    |> result.map_error(fn(error) { error.message })
    |> result.map(fn(_) { Nil })

  use _ <- result.try(database.close(connection))
  use _ <- result.try(res)

  search_by_email(user.email)
  |> result.map(fn(opt_user) {
    option.to_result(
      opt_user,
      "Unable to find just inserted user: " <> user.email.value,
    )
  })
  |> result.flatten()
}

fn update(user: User) -> Result(User, String) {
  use connection <- result.try(database.open())

  let res =
    sqlight.query(
      "UPDATE users set email = ?, hash = ? WHERE ",
      connection,
      [sqlight.text(user.email.value), sqlight.text(user.password_hash.value)],
      decode.dynamic,
    )
    |> result.map_error(fn(error) { error.message })
    |> result.map(fn(_) { user })

  use _ <- result.try(database.close(connection))
  res
}

fn search_by_email(email: email.Email) -> Result(Option(user.User), String) {
  use connection <- result.try(database.open())

  let user_decoder = user_decoder()

  let res =
    sqlight.query(
      "SELECT id, email, hash FROM users WHERE email = ? LIMIT 1",
      connection,
      [sqlight.text(email.value)],
      user_decoder,
    )
    |> result.map_error(fn(error) { error.message })

  use _ <- result.try(database.close(connection))

  res
  |> result.map(fn(users) {
    users
    |> list.first()
    |> option.from_result()
  })
}

fn exists(user: User) -> Result(Bool, String) {
  use maybe_user <- result.try(search_by_email(user.email))

  maybe_user
  |> option.is_some()
  |> Ok()
}

fn user_decoder() -> decode.Decoder(user.User) {
  use id <- decode.field(0, decode.int)
  use email_str <- decode.field(1, decode.string)
  use hash_str <- decode.field(2, decode.string)

  let decoder_email = case email.create(email_str) {
    Error(error) ->
      decode.failure(email.Email(""), "Invalid value in database: " <> error)
    Ok(value) -> decode.success(value)
  }

  let decoder_hash = case password_hash.create(hash_str) {
    Error(error) ->
      decode.failure(
        password_hash.PasswordHash(""),
        "Invalid value in database: " <> error,
      )
    Ok(value) -> decode.success(value)
  }

  use email <- decode.then(decoder_email)
  use hash <- decode.then(decoder_hash)

  decode.success(user.load(id, email, hash))
}
