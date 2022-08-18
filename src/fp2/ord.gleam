import gleam/order.{Eq, Gt, Lt, Order}

// -------------------------------------------------------------------------------------
// model
// -------------------------------------------------------------------------------------
pub type Ord(a) {
  Ord(compare: fn(a, a) -> Order)
}

// -------------------------------------------------------------------------------------
// utils
// -------------------------------------------------------------------------------------
pub fn min(o: Ord(a)) {
  fn(first: a, second: a) {
    case o.compare(first, second) {
      Eq -> first
      Lt -> first
      Gt -> second
    }
  }
}

pub fn max(o: Ord(a)) {
  fn(first: a, second: a) {
    case o.compare(first, second) {
      Eq -> first
      Lt -> second
      Gt -> first
    }
  }
}
