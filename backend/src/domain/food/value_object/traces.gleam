pub type Traces {
  Traces(
    gluten: Bool,
    crustaceans: Bool,
    eggs: Bool,
    fish: Bool,
    peanuts: Bool,
    soy: Bool,
    dairy: Bool,
    nuts: Bool,
    celery: Bool,
    mustard: Bool,
    sesame_seeds: Bool,
    sulfites: Bool,
    mollusks: Bool,
    lupins: Bool,
  )
}

pub fn default() -> Traces {
  Traces(
    False,
    False,
    False,
    False,
    False,
    False,
    False,
    False,
    False,
    False,
    False,
    False,
    False,
    False,
  )
}

pub fn create(
  gluten: Bool,
  crustaceans: Bool,
  eggs: Bool,
  fish: Bool,
  peanuts: Bool,
  soy: Bool,
  dairy: Bool,
  nuts: Bool,
  celery: Bool,
  mustard: Bool,
  sesame_seeds: Bool,
  sulfites: Bool,
  mollusks: Bool,
  lupins: Bool,
) -> Traces {
  Traces(
    gluten,
    crustaceans,
    eggs,
    fish,
    peanuts,
    soy,
    dairy,
    nuts,
    celery,
    mustard,
    sesame_seeds,
    sulfites,
    mollusks,
    lupins,
  )
}
