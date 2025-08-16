import domain/food/carta_dish
import domain/food/value_object/family_id
import domain/food/value_object/family_name

pub type CartaFamily {
  CartaFamily(
    id: family_id.FamilyId,
    name: family_name.FamilyName,
    dishes: List(carta_dish.CartaDish),
  )
}
