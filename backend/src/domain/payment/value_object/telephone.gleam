import gleam/dynamic/decode
import shared/validate

pub type TelephoneError {
  InvalidPhone(message: String)
}

pub type Telephone {
  Telephone(value: String)
}

pub fn create(maybe_phone: String) -> Result(Telephone, TelephoneError) {
  case maybe_phone |> validate.is_phone() {
    True -> Ok(Telephone(maybe_phone))
    False -> Error(InvalidPhone("invalid phone number"))
  }
}

pub fn decode(maybe_phone: String) -> decode.Decoder(Telephone) {
  case create(maybe_phone) {
    Error(InvalidPhone(message)) -> decode.failure(Telephone(""), message)
    Ok(value) -> decode.success(value)
  }
}
