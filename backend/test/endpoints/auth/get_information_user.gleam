import adapters/http/common/http_codes
import gleeunit/should
import tools/database_setup
import tools/db_utils
import tools/e2e_utils
import tools/shouldx

const target = "/v1/me"

pub fn get_user_information_ok_no_restaurant_test() {
  use <- database_setup.with_clean_db()

  use response <- e2e_utils.get_authenticated_json(
    db_utils.registered_user(),
    target,
    [],
  )

  response.status |> should.equal(http_codes.ok)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("email")
  body |> shouldx.contain(db_utils.registered_user_email())
  body |> shouldx.not_contain("id")
}

pub fn get_user_information_ok_test() {
  use <- database_setup.with_clean_db()

  use response <- e2e_utils.get_authenticated_json(
    db_utils.user_full_restaurant(),
    target,
    [],
  )

  response.status |> should.equal(http_codes.ok)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("email")
  body |> shouldx.contain(db_utils.user_full_restaurant_email())
  body |> shouldx.not_contain("id")
}

pub fn get_user_information_ko_unauthenticated() {
  use <- database_setup.with_clean_db()

  use response <- e2e_utils.get_json(target, [])

  response.status |> should.equal(http_codes.unauthorized)
}
