import fp_gl/models.{type Eq}

pub fn from_equals(equals: fn(a, a) -> Bool) -> Eq(a) {
  equals
}

// -------------------------------------------------------------------------------------
// primitives
// -------------------------------------------------------------------------------------

pub fn generic() -> Eq(a) {
  fn(a: a, b: a) { a == b }
}

pub fn int() -> Eq(Int) {
  fn(a: Int, b: Int) { a == b }
}

pub fn float() -> Eq(Float) {
  fn(a: Float, b: Float) { a == b }
}

pub fn string() -> Eq(String) {
  fn(a: String, b: String) { a == b }
}

pub fn bool() -> Eq(Bool) {
  fn(a: Bool, b: Bool) { a == b }
}
