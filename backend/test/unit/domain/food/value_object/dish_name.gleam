import domain/food/value_object/dish_name.{DishName, InvalidName, create}
import gleeunit/should

pub fn create_cartaname_with_valid_value_test() {
  let name = "arroz con pollo al curry"
  let result = create(name)
  result
  |> should.equal(Ok(DishName("arroz con pollo al curry")))
}

pub fn create_cartaname_with_empty_value_test() {
  let name = ""
  let result = create(name)
  result
  |> should.equal(Error(InvalidName("empty name")))
}
