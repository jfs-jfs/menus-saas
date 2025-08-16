import domain/food/value_object/dish_description.{
  DishDescription, InvalidDescription, create,
}
import gleeunit/should

pub fn create_cartaname_with_valid_value_test() {
  let name = "Menu 1"
  let result = create(name)
  result
  |> should.equal(Ok(DishDescription("Menu 1")))
}

pub fn create_cartaname_with_empty_value_test() {
  let name = ""
  let result = create(name)
  result
  |> should.equal(Error(InvalidDescription("empty name")))
}
