import domain/food/value_object/traces.{Traces, create, default}
import gleeunit/should

pub fn default_traces_test() {
  let expected =
    Traces(
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

  let result = default()
  result
  |> should.equal(expected)
}

pub fn create_traces_with_custom_values_test() {
  let result =
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

  let expected =
    Traces(
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

  result
  |> should.equal(expected)
}

pub fn create_traces_all_true_test() {
  let result =
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

  let expected =
    Traces(
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

  result
  |> should.equal(expected)
}
