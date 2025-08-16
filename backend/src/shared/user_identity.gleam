import domain/auth/user.{type User}
import domain/auth/value_objects/user_id
import domain/payment/value_object/owner_id
import gleam/option
import gleam/result
import shared/value_object/numeric_id

pub type UserIdentity {
  UserIdentity(numeric_id.NumericId)
}

pub type UserIdentityError {
  UnableToBuild
}

pub fn from_user(user: User) -> Result(UserIdentity, UserIdentityError) {
  use user_id <- result.try(option.to_result(user.id, UnableToBuild))
  let user_id.UserId(numeric_id) = user_id
  UserIdentity(numeric_id) |> Ok
}

pub fn to_user(id: UserIdentity) -> user_id.UserId {
  let UserIdentity(id) = id
  user_id.UserId(id)
}

pub fn to_owner(id: UserIdentity) -> owner_id.OwnerId {
  let UserIdentity(id) = id
  owner_id.OwnerId(id)
}
