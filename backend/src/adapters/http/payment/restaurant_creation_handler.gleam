import adapters/http/common/handler_tools
import adapters/http/common/http_codes
import adapters/http/common/http_error.{type HttpError}
import adapters/http/payment/request_decoders/restaurant_creation_request
import adapters/http/types.{type AuthRequest, AuthRequest}
import gleam/http
import gleam/result
import ports/usecases/payment/create_restaurant.{
  type CreateRestaurant, type CreateRestaurantError, Internal,
  RestaurantAlreadyExist,
}
import shared/user_identity
import wisp.{type Response}

pub fn handle(auth_request: AuthRequest, usecase: CreateRestaurant) -> Response {
  let AuthRequest(identifier, request) = auth_request
  use <- wisp.require_method(request, http.Post)

  use body <- handler_tools.with_decoded_json_body(
    request,
    restaurant_creation_request.decoder(identifier |> user_identity.to_owner()),
  )

  body
  |> usecase.execute()
  |> translate_error()
  |> http_error.to_response()
  |> result.unwrap_error(wisp.no_content())
}

fn translate_error(
  res: Result(a, CreateRestaurantError),
) -> Result(a, HttpError) {
  use error <- result.map_error(res)
  case error {
    Internal(_) ->
      http_error.HttpError(http_codes.internal_server_error, "try again later")
    RestaurantAlreadyExist ->
      http_error.HttpError(
        http_codes.conflict,
        "this user already has a restaurant",
      )
  }
}
