import domain/food/value_object/price.{
  EuroCents, FreePrice, NegativeValue, create,
}
import gleeunit/should

pub fn create_price_with_valid_value_test() {
  let cents = 250
  let result = create(cents)
  result
  |> should.equal(Ok(EuroCents(250)))
}

pub fn create_price_with_zero_value_test() {
  let cents = 0
  let result = create(cents)
  result
  |> should.equal(Error(FreePrice))
}

pub fn create_price_with_negative_value_test() {
  let cents = -50
  let result = create(cents)
  result
  |> should.equal(Error(NegativeValue))
}
