import gleam/order.{Eq, Gt, Lt}
import fp_gl/models.{
  type Monoid, type Ord, type Semigroup, Monoid, Ord, Semigroup,
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

// -------------------------------------------------------------------------------------
// instances
// -------------------------------------------------------------------------------------

pub fn get_semigroup() -> Semigroup(Ord(a)) {
  Semigroup(fn(first: Ord(a), second: Ord(a)) {
    Ord(fn(a: a, b: a) {
      let first_res = first.compare(a, b)
      case first_res {
        Eq -> second.compare(a, b)
        _ -> first_res
      }
    })
  })
}

pub fn get_monoid() -> Monoid(Ord(a)) {
  Monoid(get_semigroup().concat, Ord(fn(_, _) { Eq }))
}
