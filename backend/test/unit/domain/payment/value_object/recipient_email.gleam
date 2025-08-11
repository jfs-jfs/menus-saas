import domain/payment/value_object/recipient_email
import gleeunit/should

pub fn recipient_email_ok_test() {
  let assert Ok(_) = recipient_email.create("a.valid.email@here.com")
  let assert Ok(_) = recipient_email.create("test@gmail.com")
  let assert Ok(_) = recipient_email.create("test@outlook.com")
  let assert Ok(_) = recipient_email.create("el.de@la.terra")
  let assert Ok(_) = recipient_email.create("something@something.cat")
}

pub fn recipient_email_ko_test() {
  let assert Error(_) = recipient_email.create("not a email")
  let assert Error(_) = recipient_email.create("not@email")
  let assert Error(_) = recipient_email.create("@still.not")
  let assert Error(_) = recipient_email.create("an.email@")
  let assert Error(recipient_email.InvalidFormat(error)) =
    recipient_email.create("meh.meh")

  error |> should.equal("invalid email format")
}
