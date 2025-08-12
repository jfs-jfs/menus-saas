import domain/payment/restaurant.{type Restaurant}
import domain/payment/value_object/owner_id

pub type RestaurantRepositoryError {
  DatabaseError(message: String)
  RestaurantNotFound
  RestaurantAlreadyExists
}

pub type RestaurantRepository {
  RestaurantRepository(
    save: fn(Restaurant) -> Result(Restaurant, RestaurantRepositoryError),
    search_by_owner: fn(owner_id.OwnerId) ->
      Result(Restaurant, RestaurantRepositoryError),
  )
}
