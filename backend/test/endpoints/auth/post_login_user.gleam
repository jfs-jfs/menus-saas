import adapters/http/common/http_codes
import gleeunit/should
import tools/database_setup
import tools/db_utils
import tools/e2e_utils
import tools/shouldx

const target = "/v1/auth/login"

pub fn login_user_ok_test() {
  use <- database_setup.with_clean_db()

  let request = "
  {
    \"email\": \"" <> db_utils.registered_user_email() <> "\",
    \"password\": \"" <> db_utils.registered_user_password() <> "\"
  }
  "

  use response <- e2e_utils.post_json(target, [], request)
  should.equal(response.status, http_codes.ok)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("token")
}

pub fn login_user_ko_wrong_methods_test() {
  use <- database_setup.with_clean_db()

  let request = "
  {
    \"email\": \"" <> db_utils.unregistered_user_email() <> "\",
    \"password\": \"" <> db_utils.unregistered_user_password() <> "\"
  }
  "

  use response <- e2e_utils.get_json(target, [])
  response.status |> should.equal(http_codes.method_not_allowed)

  use response <- e2e_utils.put_json(target, [], request)
  response.status |> should.equal(http_codes.method_not_allowed)

  use response <- e2e_utils.patch_json(target, [], request)
  response.status |> should.equal(http_codes.method_not_allowed)

  use response <- e2e_utils.delete_json(target, [], request)
  response.status |> should.equal(http_codes.method_not_allowed)
}

pub fn login_user_ko_empty_request_test() {
  use <- database_setup.with_clean_db()

  let request = "{}"

  use response <- e2e_utils.post_json(target, [], request)
  response.status |> should.equal(http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("email")
  body |> shouldx.contain("password")
  body |> shouldx.contain("field was expected but found nothing")
}

pub fn login_user_ko_user_doesnt_exists_test() {
  use <- database_setup.with_clean_db()

  let request = "
  {
    \"email\": \"" <> db_utils.unregistered_user_email() <> "\",
    \"password\": \"" <> db_utils.unregistered_user_password() <> "\"
  }
  "

  use response <- e2e_utils.post_json(target, [], request)
  response.status |> should.equal(http_codes.unauthorized)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invalid credentials")
}

pub fn login_user_ko_invalid_parameters_test() {
  use <- database_setup.with_clean_db()

  let request = "
  {
    \"email\": \"" <> db_utils.invalid_email() <> "\",
    \"password\": \"" <> db_utils.invalid_password() <> "\"
  }
  "

  use response <- e2e_utils.post_json(target, [], request)
  response.status |> should.equal(http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invalid")
}

pub fn login_user_ko_invalid_password_test() {
  use <- database_setup.with_clean_db()

  let request = "
  {
    \"email\": \"" <> db_utils.registered_user_email() <> "\",
    \"password\": \"" <> db_utils.invalid_password() <> "\"
  }
  "

  use response <- e2e_utils.post_json(target, [], request)
  response.status |> should.equal(http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invalid password format")
}

pub fn login_user_ko_invalid_email_test() {
  use <- database_setup.with_clean_db()

  let request = "
  {
    \"email\": \"" <> db_utils.invalid_email() <> "\",
    \"password\": \"" <> db_utils.registered_user_password() <> "\"
  }
  "

  use response <- e2e_utils.post_json(target, [], request)
  response.status |> should.equal(http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invalid email format")
  body |> shouldx.contain(db_utils.invalid_email())
}

pub fn login_user_ko_missing_password_test() {
  use <- database_setup.with_clean_db()

  let request = "
  {
    \"email\": \"" <> db_utils.registered_user_email() <> "\"
  }
  "

  use response <- e2e_utils.post_json(target, [], request)
  response.status |> should.equal(http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("password")
  body |> shouldx.contain("field was expected but found nothing")
}

pub fn login_user_ko_missing_email_test() {
  use <- database_setup.with_clean_db()

  let request = "
  {
    \"password\": \"" <> db_utils.registered_user_password() <> "\"
  }
  "

  use response <- e2e_utils.post_json(target, [], request)
  response.status |> should.equal(http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("email")
  body |> shouldx.contain("field was expected but found nothing")
}
