import domain/payment/restaurant.{type Restaurant}
import domain/payment/value_object/owner_id
import gleam/option.{type Option, None, Some}
import gleam/result
import ports/repositories/restaurant_repository.{
  type RestaurantRepository, type RestaurantRepositoryError, DatabaseError,
  RestaurantAlreadyExists,
}
import shared/state

pub type SearchRestaurantError {
  RestaurantNotFound
  NoCriteriaSetInRequest
  Internal(message: String)
}

pub type SearchRestaurantRequest {
  SearchRestaurantRequest(by_owner: Option(owner_id.OwnerId))
}

pub type SearchRestaurant {
  SearchRestaurant(
    execute: fn(SearchRestaurantRequest) ->
      Result(Restaurant, SearchRestaurantError),
  )
}

pub fn build(repository: RestaurantRepository) -> SearchRestaurant {
  SearchRestaurant(execute: execute(_, repository))
}

fn execute(
  request: SearchRestaurantRequest,
  repository: RestaurantRepository,
) -> Result(Restaurant, SearchRestaurantError) {
  let SearchRestaurantRequest(by_owner:) = request
  case by_owner {
    None -> Error(NoCriteriaSetInRequest)
    Some(owner) -> repository.search_by_owner(owner) |> translate_error()
  }
}

fn translate_error(
  res: Result(a, RestaurantRepositoryError),
) -> Result(a, SearchRestaurantError) {
  use error <- result.map_error(res)
  case error {
    DatabaseError(message:) -> Internal(message)
    restaurant_repository.RestaurantNotFound -> RestaurantNotFound
    RestaurantAlreadyExists ->
      state.impossible_state_reached(
        "SearchRestaurant -> translate_error",
        "impossible to recieve already exists error when I am searching for it",
      )
  }
}
