import domain/food/value_object/aviability.{Aviability, create, default}
import gleeunit/should

pub fn default_aviability_test() {
  let expected =
    Aviability(False, True, True, True, True, True, True, True, True, True)

  default()
  |> should.equal(expected)
}

pub fn create_aviability_with_custom_values_test() {
  let aviability =
    create(True, False, True, False, True, False, True, False, True, False)

  aviability
  |> should.equal(Aviability(
    True,
    False,
    True,
    False,
    True,
    False,
    True,
    False,
    True,
    False,
  ))
}

pub fn create_aviability_all_true_test() {
  let aviability =
    create(True, True, True, True, True, True, True, True, True, True)

  aviability
  |> should.equal(Aviability(
    True,
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
