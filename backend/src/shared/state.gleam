import wisp

pub fn impossible_state_reached(place: String, reason: String) {
  let error = "[" <> place <> "] Impossible state reached :: " <> reason
  wisp.log_critical(error)
  panic as error
}

pub fn lazy_carsh(place: String, reason: String) {
  fn() { impossible_state_reached(place, reason) }
}
