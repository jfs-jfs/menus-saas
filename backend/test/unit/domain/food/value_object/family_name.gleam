import domain/food/value_object/family_name.{FamilyName, InvalidName, create}
import gleeunit/should

pub fn create_cartaname_with_valid_value_test() {
  let name = "Entrantes"
  let result = create(name)
  result
  |> should.equal(Ok(FamilyName("Entrantes")))
}

pub fn create_cartaname_with_empty_value_test() {
  let name = ""
  let result = create(name)
  result
  |> should.equal(Error(InvalidName("empty name")))
}
