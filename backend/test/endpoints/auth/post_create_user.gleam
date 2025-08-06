import app/router
import gleam/json
import tools/database_setup
import tools/db_utils
import wisp/testing

const target = "/auth/register"

pub fn create_user_ok_test() {
  use <- database_setup.with_clean_db()

  let response =
    router.handle_request(testing.post_json(
      target,
      [],
      json.object([
        #("email", json.string(db_utils.unregistered_user_email())),
        #("password", json.string(db_utils.unregistered_user_password())),
      ]),
    ))

  echo response
  Nil
}
