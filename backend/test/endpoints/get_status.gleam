import tools/e2e_utils

pub fn ok_test() {
  use response <- e2e_utils.get_json("/status", [])
  assert response.status == 200
}
