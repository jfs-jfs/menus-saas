import domain/food/menu_dish
import domain/food/value_object/family_id
import domain/food/value_object/family_name

pub type MenuFamily {
  MenuFamily(
    id: family_id.FamilyId,
    name: family_name.FamilyName,
    dishes: List(menu_dish.MenuDish),
  )
}
