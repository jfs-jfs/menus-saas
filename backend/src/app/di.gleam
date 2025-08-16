import adapters/hasher/sha256_hasher
import adapters/http/auth/user_creation_handler
import adapters/http/auth/user_information_handler
import adapters/http/auth/user_login_handler
import adapters/http/payment/restaurant_creation_handler
import adapters/http/payment/restaurant_information_handler
import adapters/http/status_handler
import adapters/jwt/jwt_token_service
import adapters/sqlite/sqlite_restaurant_repository
import adapters/sqlite/sqlite_user_repository
import ports/repositories/restaurant_repository
import ports/repositories/user_repository
import ports/services/authentication_service
import ports/services/hasher_service
import ports/usecases/auth/authenticate_user
import ports/usecases/auth/create_user
import ports/usecases/auth/search_user
import ports/usecases/payment/create_restaurant
import ports/usecases/payment/search_restaurant

import adapters/http/types.{type HttpPrivateHandler, type HttpPublicHandler}

pub type RepositoriesBag {
  RepositoriesBag(
    user: user_repository.UserRepository,
    restaurant: restaurant_repository.RestaurantRepository,
  )
}

pub type ServicesBag {

  ServicesBag(
    auth: authentication_service.AuthenticationService,
    hasher: hasher_service.HasherService,
  )
}

pub type UsecasesBag {
  UsecasesBag(
    create_user: create_user.CreateUser,
    auth_user: authenticate_user.AuthenticateUser,
    search_user: search_user.SearchUser,
    create_restaurant: create_restaurant.CreateRestaurant,
    search_restaurant: search_restaurant.SearchRestaurant,
  )
}

pub type HttpHandlersBag {
  HttpHandlerBag(
    // Misc
    status: HttpPublicHandler,
    // Auth Domain
    auth_signup: HttpPublicHandler,
    auth_login: HttpPublicHandler,
    user_information: HttpPrivateHandler,
    // Payment Domain
    restaurant_creation: HttpPrivateHandler,
    restaurant_information: HttpPrivateHandler,
  )
}

pub type Bag {
  Bag(
    services: ServicesBag,
    repositories: RepositoriesBag,
    usecases: UsecasesBag,
    http_handlers: HttpHandlersBag,
  )
}

pub fn build() -> Bag {
  let services =
    ServicesBag(hasher: sha256_hasher.build(), auth: jwt_token_service.build())

  let repos =
    RepositoriesBag(
      user: sqlite_user_repository.build(),
      restaurant: sqlite_restaurant_repository.build(),
    )

  let usecases =
    UsecasesBag(
      search_user: search_user.build(repos.user),
      create_user: create_user.build(repos.user),
      create_restaurant: create_restaurant.build(repos.restaurant),
      auth_user: authenticate_user.build(repos.user, services.auth),
      search_restaurant: search_restaurant.build(repos.restaurant),
    )

  let handlers =
    HttpHandlerBag(
      status: status_handler.handle,
      auth_signup: user_creation_handler.handle(
        _,
        usecases.create_user,
        services.hasher,
      ),
      auth_login: user_login_handler.handle(
        _,
        services.hasher,
        usecases.auth_user,
      ),
      user_information: user_information_handler.handle(_, usecases.search_user),
      restaurant_creation: restaurant_creation_handler.handle(
        _,
        usecases.create_restaurant,
      ),
      restaurant_information: restaurant_information_handler.handle(
        _,
        usecases.search_restaurant,
      ),
    )
  Bag(services:, usecases:, http_handlers: handlers, repositories: repos)
}
