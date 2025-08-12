import gleam/dynamic/decode
import gleam/json
import gleam/string

pub type CityError {
  UnknownCity(message: String)
}

pub type City {
  City(value: String)
}

pub fn to_json(city: City) -> json.Json {
  json.string(city.value)
}

pub fn create(maybe_city: String) -> Result(City, CityError) {
  case string.is_empty(maybe_city) {
    False -> Ok(City(maybe_city))
    True -> Error(UnknownCity("unknown city"))
  }
}

pub fn decode(maybe_city: String) -> decode.Decoder(City) {
  case create(maybe_city) {
    Error(UnknownCity(message)) -> decode.failure(City(""), message)
    Ok(value) -> decode.success(value)
  }
}
