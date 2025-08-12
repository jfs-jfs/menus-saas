import adapters/http/common/http_codes
import gleeunit/should
import tools/database_setup
import tools/db_utils
import tools/e2e_utils
import tools/shouldx

const target = "/v1/restaurant"

pub fn get_information_ok_full_test() {
  use <- database_setup.with_clean_db()

  use response <- e2e_utils.get_authenticated_json(
    db_utils.user_full_restaurant(),
    target,
    [],
  )

  response.status |> should.equal(http_codes.ok)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("name")
  body |> shouldx.contain("phone")
  body |> shouldx.contain("address_street")
  body |> shouldx.contain("address_city")
  body |> shouldx.contain("address_street")
  body |> shouldx.contain("invoice")
  body |> shouldx.contain("nif")
  body |> shouldx.contain("recipient")
  body |> shouldx.contain("recipient_email")
  body |> shouldx.contain("address_postal_code")
  body |> shouldx.contain("address_building_number")
  body |> shouldx.not_contain("id")
  body |> shouldx.not_contain("owner_id")
}

pub fn get_information_ok_no_invoice_test() {
  use <- database_setup.with_clean_db()

  use response <- e2e_utils.get_authenticated_json(
    db_utils.user_no_invoice_info(),
    target,
    [],
  )

  response.status |> should.equal(http_codes.ok)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("name")
  body |> shouldx.contain("phone")
  body |> shouldx.contain("address_street")
  body |> shouldx.contain("address_city")
  body |> shouldx.contain("address_street")
  body |> shouldx.contain("invoice")
  body |> shouldx.contain("null")
  body |> shouldx.not_contain("nif")
  body |> shouldx.not_contain("recipient")
  body |> shouldx.not_contain("recipient_email")
  body |> shouldx.not_contain("address_postal_code")
  body |> shouldx.not_contain("address_building_number")
  body |> shouldx.not_contain("id")
  body |> shouldx.not_contain("owner_id")
}

pub fn get_information_ko_no_restaurant_test() {
  use <- database_setup.with_clean_db()

  use response <- e2e_utils.get_authenticated_json(
    db_utils.user_no_restaurant(),
    target,
    [],
  )

  response.status |> should.equal(http_codes.not_found)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("user hasn't assigned a restaurant yet")
}

pub fn get_information_ko_unauthenticated() {
  use <- database_setup.with_clean_db()

  use response <- e2e_utils.get_json(target, [])

  response.status |> should.equal(http_codes.unauthorized)
}
