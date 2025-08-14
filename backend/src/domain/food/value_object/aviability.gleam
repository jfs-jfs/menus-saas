pub type Aviability {
  Aviability(
    breakfast: Bool,
    lunch: Bool,
    dinner: Bool,
    monday: Bool,
    tuesday: Bool,
    wensday: Bool,
    thursday: Bool,
    friday: Bool,
    saturday: Bool,
    sunday: Bool,
  )
}

pub fn default() -> Aviability {
  Aviability(
    breakfast: False,
    lunch: True,
    dinner: True,
    monday: True,
    tuesday: True,
    wensday: True,
    thursday: True,
    friday: True,
    saturday: True,
    sunday: True,
  )
}

pub fn create(
  breakfast: Bool,
  lunch: Bool,
  dinner: Bool,
  monday: Bool,
  tuesday: Bool,
  wensday: Bool,
  thursday: Bool,
  friday: Bool,
  saturday: Bool,
  sunday: Bool,
) -> Aviability {
  Aviability(
    breakfast:,
    lunch:,
    dinner:,
    monday:,
    tuesday:,
    wensday:,
    thursday:,
    friday:,
    saturday:,
    sunday:,
  )
}
