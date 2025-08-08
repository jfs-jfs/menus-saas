import domain/auth/user.{type User}
import domain/auth/value_objects/user_id
import domain/payment/value_object/owner_id
import gleam/option
import gleam/result

pub type UserIdentity {
  UserIdentity(Int)
}

pub type UserIdentityError {
  UnableToBuild
}

pub fn from_user(user: User) -> Result(UserIdentity, UserIdentityError) {
  user.id
  |> option.to_result(UnableToBuild)
  |> result.map(fn(user_id) { UserIdentity(user_id.value) })
}

pub fn to_user(id: UserIdentity) -> user_id.UserId {
  let UserIdentity(id) = id
  user_id.UserId(id)
}

pub fn to_owner(id: UserIdentity) -> owner_id.OwnerId {
  let UserIdentity(id) = id
  owner_id.OwnerId(id)
}
