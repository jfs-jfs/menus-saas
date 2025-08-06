import gleeunit/should
import shared/http_codes
import tools/database_setup
import tools/db_utils
import tools/e2e_utils
import tools/shouldx

const target = "/auth/register"

pub fn create_user_ok_test() {
  use <- database_setup.with_clean_db()

  let request = "
  {
    \"email\": \"" <> db_utils.unregistered_user_email() <> "\",
    \"password\": \"" <> db_utils.unregistered_user_password() <> "\"
  }
  "

  use response <- e2e_utils.post_json(target, [], request)
  // response |> e2e_utils.print_response() 

  should.equal(response.status, http_codes.ok)
  should.equal(e2e_utils.extract_body(response), "[]")
}

pub fn create_user_ko_user_already_exists_test() {
  use <- database_setup.with_clean_db()

  let request = "
  {
    \"email\": \"" <> db_utils.registered_user_email() <> "\",
    \"password\": \"" <> db_utils.registered_user_password() <> "\"
  }
  "

  use response <- e2e_utils.post_json(target, [], request)
  response |> e2e_utils.print_response()
  should.equal(response.status, http_codes.conflict)
  should.equal(e2e_utils.extract_body(response), "[]")
}

pub fn create_user_ko_invalid_parameters_test() {
  use <- database_setup.with_clean_db()

  let request = "
  {
    \"email\": \"" <> db_utils.invalid_email() <> "\",
    \"password\": \"" <> db_utils.invalid_password() <> "\"
  }
  "

  use response <- e2e_utils.post_json(target, [], request)
  // response |> e2e_utils.print_response()

  let body = e2e_utils.extract_body(response)

  should.equal(response.status, http_codes.bad_request)
  body |> shouldx.contain("invalid")
}

pub fn create_user_ko_invalid_password_test() {
  use <- database_setup.with_clean_db()

  let request = "
  {
    \"email\": \"" <> db_utils.unregistered_user_email() <> "\",
    \"password\": \"" <> db_utils.invalid_password() <> "\"
  }
  "

  use response <- e2e_utils.post_json(target, [], request)
  // response |> e2e_utils.print_response()

  let body = e2e_utils.extract_body(response)

  should.equal(response.status, http_codes.bad_request)
  body |> shouldx.contain("invalid password format")
}

pub fn create_user_ko_invalid_email_test() {
  use <- database_setup.with_clean_db()

  let request = "
  {
    \"email\": \"" <> db_utils.invalid_email() <> "\",
    \"password\": \"" <> db_utils.unregistered_user_password() <> "\"
  }
  "

  use response <- e2e_utils.post_json(target, [], request)
  // response |> e2e_utils.print_response()

  let body = e2e_utils.extract_body(response)

  should.equal(response.status, http_codes.bad_request)
  shouldx.contain(body, "invalid email format")
  shouldx.contain(body, db_utils.invalid_email())
}

pub fn create_user_ko_missing_password_test() {
  use <- database_setup.with_clean_db()

  let request = "
  {
    \"email\": \"" <> db_utils.unregistered_user_email() <> "\"
  }
  "

  use response <- e2e_utils.post_json(target, [], request)
  // response |> e2e_utils.print_response()

  let body = e2e_utils.extract_body(response)

  should.equal(response.status, http_codes.bad_request)
  shouldx.contain(body, "password")
  shouldx.contain(body, "field was expected but found nothing")
}

pub fn create_user_ko_missing_email_test() {
  use <- database_setup.with_clean_db()

  let request = "
  {
    \"password\": \"" <> db_utils.unregistered_user_password() <> "\"
  }
  "

  use response <- e2e_utils.post_json(target, [], request)
  // response |> e2e_utils.print_response()

  let body = e2e_utils.extract_body(response)

  should.equal(response.status, http_codes.bad_request)
  shouldx.contain(body, "email")
  shouldx.contain(body, "field was expected but found nothing")
}
