import app/router
import wisp/testing

pub fn ok_test() {
  let response = router.handle_request(testing.get("/status", []))
  assert response.status == 200
}
