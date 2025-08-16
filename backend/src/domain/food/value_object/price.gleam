pub type PriceError {
  NegativeValue
  FreePrice
}

pub type Price {
  EuroCents(value: Int)
}

pub fn create(maybe_price: Int) -> Result(Price, PriceError) {
  case maybe_price {
    0 -> Error(FreePrice)
    x if x < 0 -> Error(NegativeValue)
    value -> Ok(EuroCents(value))
  }
}
