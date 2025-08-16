import gleam/dynamic/decode
import gleam/json
import gleam/string

pub type ProvinceError {
  InvalidProvince(message: String)
}

pub type Province {
  Province(value: String)
}

pub fn to_json(province: Province) -> json.Json {
  json.string(province.value)
}

pub fn create(maybe_province: String) -> Result(Province, ProvinceError) {
  case string.is_empty(maybe_province) {
    True -> Error(InvalidProvince("invalid province"))
    False -> Ok(Province(maybe_province))
  }
}

pub fn decode(maybe_province: String) -> decode.Decoder(Province) {
  case create(maybe_province) {
    Ok(value) -> decode.success(value)
    Error(InvalidProvince(message)) -> decode.failure(Province(""), message)
  }
}
