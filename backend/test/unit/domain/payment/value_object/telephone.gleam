import domain/payment/value_object/telephone

pub fn telephone_creation_ok_test() {
  let assert Ok(telephone.Telephone(_)) = telephone.create("0034 676616562")
  let assert Ok(telephone.Telephone(_)) = telephone.create("676616562")
  let assert Ok(telephone.Telephone(_)) = telephone.create("0034676616562")
  let assert Ok(telephone.Telephone(_)) = telephone.create("+34676616562")
  let assert Ok(telephone.Telephone(_)) = telephone.create("+34 676616562")
}

pub fn telephone_creation_ko_test() {
  let assert Error(telephone.InvalidPhone(_)) = telephone.create("hola perloa")
  let assert Error(telephone.InvalidPhone(_)) = telephone.create("")
  let assert Error(telephone.InvalidPhone(_)) = telephone.create("123456789")
  let assert Error(telephone.InvalidPhone(_)) = telephone.create("als;kdfj")
}
