import domain/food/value_object/attributes.{Attributes, create, default}
import gleeunit/should

pub fn default_attributes_test() {
  let expected =
    Attributes(False, False, False, False, False, False, False, False, False)
  default()
  |> should.equal(expected)
}

pub fn create_attributes_with_custom_values_test() {
  let attributes =
    create(True, False, True, False, True, False, True, False, True)

  attributes
  |> should.equal(Attributes(
    True,
    False,
    True,
    False,
    True,
    False,
    True,
    False,
    True,
  ))
}

pub fn create_attributes_all_true_test() {
  let attributes = create(True, True, True, True, True, True, True, True, True)

  attributes
  |> should.equal(Attributes(
    True,
    True,
    True,
    True,
    True,
    True,
    True,
    True,
    True,
  ))
}
