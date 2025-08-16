import domain/food/menu_family
import domain/food/value_object/aviability
import domain/food/value_object/establishment_id
import domain/food/value_object/menu_id
import domain/food/value_object/menu_name
import domain/food/value_object/price
import gleam/option

pub type Menu {
  Menu(
    id: menu_id.MenuId,
    establishment: establishment_id.EstablishmentId,
    name: menu_name.MenuName,
    aviability: aviability.Aviability,
    price: price.Price,
    half_price: option.Option(price.Price),
    items: List(menu_family.MenuFamily),
  )
}
