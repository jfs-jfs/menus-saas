import domain/food/menu_family
import domain/food/value_object/aviability
import domain/food/value_object/carta_id
import domain/food/value_object/carta_name
import domain/food/value_object/place_id

pub type Carta {
  Carta(
    id: carta_id.CartaId,
    place: place_id.PlaceId,
    name: carta_name.CartaName,
    aviability: aviability.Aviability,
    items: List(menu_family.MenuFamily),
  )
}
