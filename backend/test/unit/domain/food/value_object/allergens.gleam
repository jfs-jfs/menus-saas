import domain/food/value_object/allergens.{Allergens, create, default}
import gleeunit/should

pub fn default_allergens_test() {
  let expected =
    Allergens(
      False,
      False,
      False,
      False,
      False,
      False,
      False,
      False,
      False,
      False,
      False,
      False,
      False,
      False,
    )
  default()
  |> should.equal(expected)
}

pub fn create_allergens_with_custom_values_test() {
  let allergens =
    create(
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
      True,
      False,
      True,
      False,
    )

  allergens
  |> should.equal(Allergens(
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
    True,
    False,
    True,
    False,
  ))
}

pub fn create_allergens_all_true_test() {
  let allergens =
    create(
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
      True,
      True,
      True,
      True,
    )

  allergens
  |> should.equal(Allergens(
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
    True,
    True,
    True,
    True,
  ))
}
