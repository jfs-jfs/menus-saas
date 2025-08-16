import adapters/hasher/sha256_hasher

pub fn user_no_restaurant() -> #(String, String) {
  #("no.restaurant@restaurant.com", "234@HOla")
}

pub fn user_no_restaurant_email() -> String {
  user_no_restaurant().0
}

pub fn user_no_restaurant_hash() -> String {
  sha256_hasher.build().hash(user_no_restaurant().1)
}

pub fn user_full_restaurant() -> #(String, String) {
  #("full.restaurant@restaurant.com", "2081@Shiiit")
}

pub fn user_full_restaurant_email() -> String {
  user_full_restaurant().0
}

pub fn user_full_restaurant_hash() -> String {
  sha256_hasher.build().hash(user_full_restaurant().1)
}

pub fn user_no_invoice_info() -> #(String, String) {
  #("no.invoice@restaurant.com", "2021@Shiiit")
}

pub fn user_no_invoice_info_email() -> String {
  user_no_invoice_info().0
}

pub fn user_no_invoice_info_hash() -> String {
  sha256_hasher.build().hash(user_no_invoice_info().1)
}

pub fn unregistered_user() -> #(String, String) {
  #("unregistered@email.com", "2025@Shhhht")
}

pub fn unregistered_user_email() -> String {
  unregistered_user().0
}

pub fn unregistered_user_password() -> String {
  unregistered_user().1
}

pub fn registered_user() -> #(String, String) {
  #("registered@email.com", "2025@Secret")
}

pub fn registered_user_hash() -> String {
  sha256_hasher.build().hash(registered_user().1)
}

pub fn registered_user_email() -> String {
  registered_user().0
}

pub fn registered_user_password() -> String {
  registered_user().1
}

pub fn invalid_email() -> String {
  "invalid@invalid"
}

pub fn invalid_password() -> String {
  "1234"
}

pub fn get_restaurant_name() -> String {
  "La madre de Juan"
}

pub fn get_invalid_restaurant_name() -> String {
  ""
}

pub fn get_phone() -> String {
  "+34 676616562"
}

pub fn get_invalid_phone() -> String {
  "1573590283"
}

pub fn get_province() -> String {
  "Barcelona"
}

pub fn get_invalid_province() -> String {
  ""
}

pub fn get_city() -> String {
  "Zaragoza"
}

pub fn get_invalid_city() -> String {
  ""
}

pub fn get_street() -> String {
  "Carrer del Pinyo"
}

pub fn get_invalid_street() -> String {
  ""
}

pub fn get_nif() -> String {
  "12345678Z"
}

pub fn get_invalid_nif() -> String {
  "skdjf"
}

pub fn get_name() -> String {
  "Antonio de la Pera"
}

pub fn get_invalid_name() -> String {
  ""
}

pub fn get_email() -> String {
  "lapolla@records.es"
}

pub fn get_invalid_email() -> String {
  "eeeeh@aaaah"
}

pub fn get_postal_code() -> String {
  "08100"
}

pub fn get_invalid_postal_code() -> String {
  "1234567890"
}

pub fn get_building_number() -> String {
  "44A"
}

pub fn get_invalid_building_number() -> String {
  ""
}
