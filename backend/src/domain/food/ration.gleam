import domain/food/value_object/price
import domain/food/value_object/ration_name

pub type Ration {
  Ration(name: ration_name.RationName, price: price.Price)
}
