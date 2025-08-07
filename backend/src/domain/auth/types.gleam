import gleam/dict

pub type DecodedClaims =
  dict.Dict(String, String)

pub type AuthenticationToken =
  String
