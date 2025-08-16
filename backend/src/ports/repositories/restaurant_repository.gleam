import domain/payment/restaurant.{type Restaurant}

pub type RestaurantRepositoryError {
  DatabaseError(message: String)
  RestaurantNotFound
  RestaurantAlreadyExists
}

pub type RestaurantRepository {
  RestaurantRepository(
    save: fn(Restaurant) -> Result(Restaurant, RestaurantRepositoryError),
  )
}
