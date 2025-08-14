import domain/payment/restaurant.{type Restaurant}
import domain/payment/value_object/business_name
import domain/payment/value_object/invoice_information
import domain/payment/value_object/owner_id
import domain/payment/value_object/restaurant_address
import domain/payment/value_object/telephone
import gleam/option
import gleam/result
import ports/repositories/restaurant_repository.{
  type RestaurantRepository, type RestaurantRepositoryError, DatabaseError,
  RestaurantAlreadyExists,
}
import shared/state

pub type UpdateRestaurantError {
  RestaurantNotFound
  Internal(message: String)
}

pub type UpdateRestaurantRequest {
  UpdateRestaurantRequest(
    owner: owner_id.OwnerId,
    name: business_name.BusinessName,
    phone: telephone.Telephone,
    address: restaurant_address.RestaurantAddress,
    invoice_information: option.Option(invoice_information.InvoiceInformation),
  )
}

pub type UpdateRestaurant {
  UpdateRestaurant(
    execute: fn(UpdateRestaurantRequest) ->
      Result(Restaurant, UpdateRestaurantError),
  )
}

pub fn build(repository: RestaurantRepository) -> UpdateRestaurant {
  UpdateRestaurant(execute: execute(_, repository))
}

fn execute(
  request: UpdateRestaurantRequest,
  repository: RestaurantRepository,
) -> Result(Restaurant, UpdateRestaurantError) {
  let UpdateRestaurantRequest(
    owner:,
    name:,
    phone:,
    address:,
    invoice_information:,
  ) = request

  use restaurant <- result.try(
    repository.search_by_owner(owner) |> translate_error(),
  )

  restaurant
  |> restaurant.set_name(name)
  |> restaurant.set_phone(phone)
  |> restaurant.set_address(address)
  |> restaurant.set_invoice_information(invoice_information)
  |> repository.save()
  |> translate_error()
}

fn translate_error(
  res: Result(a, RestaurantRepositoryError),
) -> Result(a, UpdateRestaurantError) {
  use error <- result.map_error(res)
  case error {
    DatabaseError(message:) -> Internal(message)
    restaurant_repository.RestaurantNotFound -> RestaurantNotFound
    RestaurantAlreadyExists ->
      state.impossible_state_reached(
        "UpdateRestaurant -> translate_error",
        "impossible to recieve already exists error when I am searching for it",
      )
  }
}
