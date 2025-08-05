import gleam/bit_array
import gleam/crypto
import ports/services/hasher_service.{type HasherService, HasherService}

pub fn build() -> HasherService {
  HasherService(hash: hasher_function)
}

fn hasher_function(something: String) -> String {
  crypto.Sha256
  |> crypto.hash(bit_array.from_string(something))
  |> bit_array.base16_encode()
}
