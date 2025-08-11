import domain/payment/restaurant.{type Restaurant}
import domain/payment/value_object/business_name.{type BusinessName}
import domain/payment/value_object/invoice_information.{type InvoiceInformation}
import domain/payment/value_object/owner_id.{type OwnerId}
import domain/payment/value_object/restaurant_address.{type RestaurantAddress}
import domain/payment/value_object/telephone.{type Telephone}
import gleam/option.{type Option}
import gleam/result
import ports/repositories/restaurant_repository.{
  type RestaurantRepository, type RestaurantRepositoryError, DatabaseError,
  RestaurantAlreadyExists, RestaurantNotFound,
}
import shared/state

pub type CreateRestaurantError {
  Internal(message: String)
  RestaurantAlreadyExist
}

pub type CreateRestaurantRequest {
  CreateRestaurantRequest(
    owner: OwnerId,
    name: BusinessName,
    telephone: Telephone,
    address: RestaurantAddress,
    invoice_indormation: Option(InvoiceInformation),
  )
}

pub type CreateRestaurant {
  CreateRestaurant(
    execute: fn(CreateRestaurantRequest) ->
      Result(Restaurant, CreateRestaurantError),
  )
}

pub fn build(restaurant_repo: RestaurantRepository) -> CreateRestaurant {
  CreateRestaurant(execute: execute(_, restaurant_repo))
}

fn execute(
  request: CreateRestaurantRequest,
  repo: RestaurantRepository,
) -> Result(Restaurant, CreateRestaurantError) {
  restaurant.new(
    request.owner,
    request.name,
    request.address,
    request.telephone,
    request.invoice_indormation,
  )
  |> repo.save()
  |> translate_error()
}

fn translate_error(
  res: Result(a, RestaurantRepositoryError),
) -> Result(a, CreateRestaurantError) {
  use error <- result.map_error(res)
  case error {
    DatabaseError(message:) -> Internal(message:)
    RestaurantAlreadyExists -> RestaurantAlreadyExist
    RestaurantNotFound ->
      state.impossible_state_reached(
        "CreateRestaurant -> translate_error",
        "impossible to recieve not found during restaurant creation",
      )
  }
}
