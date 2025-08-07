import wisp

pub fn impossible_state_reached(place: String, reason: String) {
  let error = "[" <> place <> "] Impossible state reached :: " <> reason
  wisp.log_critical(error)
  panic as error
}
