import adapters/http/common/http_codes
import adapters/http/common/http_error.{type HttpError, HttpError}
import adapters/http/types.{type AuthRequest, AuthRequest}
import domain/payment/restaurant
import gleam/http
import gleam/json
import gleam/option.{Some}
import gleam/result
import ports/usecases/payment/search_restaurant.{
  type SearchRestaurant, type SearchRestaurantError, Internal,
  NoCriteriaSetInRequest, RestaurantNotFound,
}
import shared/state
import shared/user_identity
import wisp.{type Response}

pub fn handle(auth_request: AuthRequest, usecase: SearchRestaurant) -> Response {
  let AuthRequest(identifier, request) = auth_request
  use <- wisp.require_method(request, http.Get)

  let owner_id = identifier |> user_identity.to_owner()

  let restaurant_or_error =
    search_restaurant.SearchRestaurantRequest(Some(owner_id))
    |> usecase.execute()
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
  res: Result(a, SearchRestaurantError),
) -> Result(a, HttpError) {
  use error <- result.map_error(res)
  case error {
    Internal(_) ->
      HttpError(http_codes.internal_server_error, "try again later")
    RestaurantNotFound ->
      HttpError(http_codes.not_found, "user hasn't assigned a restaurant yet")
    NoCriteriaSetInRequest ->
      state.impossible_state_reached(
        "restaurant info handler -> translate error",
        "criteria should always be set as it comes from the request authentication",
      )
  }
}
