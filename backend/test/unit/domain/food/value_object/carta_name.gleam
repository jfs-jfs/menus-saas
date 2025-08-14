import domain/food/value_object/carta_name.{CartaName, InvalidName, create}
import gleeunit/should

pub fn create_cartaname_with_valid_value_test() {
  let name = "Carta 1"
  let result = create(name)
  result
  |> should.equal(Ok(CartaName("Carta 1")))
}

pub fn create_cartaname_with_empty_value_test() {
  let name = ""
  let result = create(name)
  result
  |> should.equal(Error(InvalidName("empty name")))
}
