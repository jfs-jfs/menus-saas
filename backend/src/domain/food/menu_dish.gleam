import domain/food/value_object/allergens
import domain/food/value_object/attributes
import domain/food/value_object/dish_description
import domain/food/value_object/dish_id
import domain/food/value_object/dish_name
import domain/food/value_object/traces
import gleam/option

pub type MenuDish {
  MenuDish(
    id: dish_id.DishId,
    name: dish_name.DishName,
    description: option.Option(dish_description.DishDescription),
    additional_information: option.Option(dish_description.DishDescription),
    attributes: attributes.Attributes,
    allergens: allergens.Allergens,
    traces: traces.Traces,
    visible: Bool,
  )
}
