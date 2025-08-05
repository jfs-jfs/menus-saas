import domain/auth/value_objects/email.{InvalidFormat}
import gleeunit/should

pub fn email_creation_ok_test() -> Nil {
  let assert Ok(_) = email.create("a.valid.email@here.com")
  let assert Ok(_) = email.create("test@gmail.com")
  let assert Ok(_) = email.create("test@outlook.com")
  let assert Ok(_) = email.create("el.de@la.terra")
  let assert Ok(_) = email.create("something@something.cat")

  Nil
}

pub fn email_creation_ko_test() -> Nil {
  let assert Error(InvalidFormat(_)) = email.create("not a email")
  let assert Error(InvalidFormat(_)) = email.create("not@email")
  let assert Error(InvalidFormat(_)) = email.create("@still.not")
  let assert Error(InvalidFormat(_)) = email.create("an.email@")
  let assert Error(InvalidFormat(error)) = email.create("meh.meh")

  should.equal("invalid email format: meh.meh", error)
}
