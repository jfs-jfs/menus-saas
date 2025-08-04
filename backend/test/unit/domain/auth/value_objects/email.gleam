import domain/auth/value_objects/email

pub fn email_creation_ok_test() -> Nil {
  let assert Ok(_) = email.create("a.valid.email@here.com")
  let assert Ok(_) = email.create("test@gmail.com")
  let assert Ok(_) = email.create("test@outlook.com")
  let assert Ok(_) = email.create("el.de@la.terra")
  let assert Ok(_) = email.create("something@something.cat")

  Nil
}

pub fn email_creation_ko_test() -> Nil {
  let assert Error(_) = email.create("not a email")
  let assert Error(_) = email.create("not@email")
  let assert Error(_) = email.create("@still.not")
  let assert Error(_) = email.create("an.email@")
  let assert Error(error) = email.create("meh.meh")

  assert error == "Invalid Email" as "Wrong error name"

  Nil
}
