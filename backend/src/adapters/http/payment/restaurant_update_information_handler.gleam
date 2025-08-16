import adapters/http/common/handler_tools
import adapters/http/common/http_codes
import adapters/http/common/http_error.{type HttpError, HttpError}
import adapters/http/payment/request_decoders/restaurant_update_request
import adapters/http/types.{type AuthRequest, AuthRequest}
import domain/payment/restaurant
import gleam/http
import gleam/json
import gleam/result
import ports/usecases/payment/update_restaurant.{type UpdateRestaurant}
import shared/user_identity
import wisp.{type Response}

pub fn handle(auth_request: AuthRequest, updater: UpdateRestaurant) -> Response {
  let AuthRequest(identifier, request) = auth_request
  use <- wisp.require_method(request, http.Put)

  let owner_id = identifier |> user_identity.to_owner()

  use update_request <- handler_tools.with_decoded_json_body(
    request,
    restaurant_update_request.decoder(owner_id),
  )

  let restaurant_or_error =
    update_request
    |> updater.execute()
    |> translate_error()
    |> http_error.to_response()

  case restaurant_or_error {
    Error(err_response) -> err_response
    Ok(restaurant) ->
      restaurant
      |> restaurant.to_json()
      |> json.to_string_tree()
      |> wisp.json_response(http_codes.ok)
  }
}

fn translate_error(
  res: Result(a, update_restaurant.UpdateRestaurantError),
) -> Result(a, HttpError) {
  use error <- result.map_error(res)
  case error {
    update_restaurant.Internal(_) ->
      HttpError(http_codes.internal_server_error, "try again later")
    update_restaurant.RestaurantNotFound ->
      HttpError(http_codes.not_found, "no restaurant associated with user")
  }
}
