import gleam/order.{Order}

pub type Semigroup(a) {
  Semigroup(concat: fn(a, a) -> a)
}

pub type Ord(a) {
  Ord(compare: fn(a, a) -> Order)
}

pub type Monoid(a) {
  Monoid(concat: fn(a, a) -> a, empty: a)
}

pub type Eq(a) =
  fn(a, a) -> Bool
