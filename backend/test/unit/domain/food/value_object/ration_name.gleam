import domain/food/value_object/ration_name.{InvalidName, RationName, create}
import gleeunit/should

pub fn create_cartaname_with_valid_value_test() {
  let name = "media ración"
  let result = create(name)
  result
  |> should.equal(Ok(RationName("media ración")))
}

pub fn create_cartaname_with_empty_value_test() {
  let name = ""
  let result = create(name)
  result
  |> should.equal(Error(InvalidName("empty name")))
}
