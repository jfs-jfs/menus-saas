import adapters/hasher/sha256_hasher

/// Get a valid user account, unregistered on the database
///
pub fn unregistered_user() -> #(String, String) {
  #("unregistered@email.com", "2025@Shhhht")
}

/// Get a valid, unregistered email
///
pub fn unregistered_user_email() -> String {
  unregistered_user().0
}

/// Get a valid, unregistered password (use registered_user_email to get the email)
///
pub fn unregistered_user_password() -> String {
  unregistered_user().1
}

/// Get a valid user account, registered on the database
///
pub fn registered_user() -> #(String, String) {
  #("registered@email.com", "2025@Secret")
}

/// Get a valid, registered hash for the account of registered_user()
///
pub fn registered_user_hash() -> String {
  sha256_hasher.build().hash(registered_user().1)
}

/// Get a valid, registered email
///
pub fn registered_user_email() -> String {
  registered_user().0
}

/// Get a valid, registered password (use registered_user_email to get the email)
///
pub fn registered_user_password() -> String {
  registered_user().1
}

/// Get an invalid email
///
pub fn invalid_email() -> String {
  "invalid@invalid"
}

/// Get an invalid password
///
pub fn invalid_password() -> String {
  "1234"
}
