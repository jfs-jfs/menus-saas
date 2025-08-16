pub type Attributes {
  Attributes(
    vegan: Bool,
    vegetarian: Bool,
    mild_spicy: Bool,
    spicy: Bool,
    very_spicy: Bool,
    new: Bool,
    homemade: Bool,
    seasonal: Bool,
    local_produce: Bool,
  )
}

pub fn default() -> Attributes {
  Attributes(False, False, False, False, False, False, False, False, False)
}

pub fn create(
  vegan: Bool,
  vegetarian: Bool,
  mild_spicy: Bool,
  spicy: Bool,
  very_spicy: Bool,
  new: Bool,
  homemade: Bool,
  seasonal: Bool,
  local_produce: Bool,
) -> Attributes {
  Attributes(
    vegan:,
    vegetarian:,
    mild_spicy:,
    spicy:,
    very_spicy:,
    new:,
    homemade:,
    seasonal:,
    local_produce:,
  )
}
