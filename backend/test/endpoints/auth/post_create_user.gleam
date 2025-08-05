import app/router
import gleam/json
import tools/database_setup
import wisp/testing

const target = "/auth/register"

pub fn create_user_ok_test() {
  use <- database_setup.with_clean_db()

  let response =
    router.handle_request(testing.post_json(
      target,
      [],
      json.object([
        #("email", json.string("testuser@gmail.com")),
        #("password", json.string("supersecret123")),
      ]),
    ))

  echo response
  Nil
}
