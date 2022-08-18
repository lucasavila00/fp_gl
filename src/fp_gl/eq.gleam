import fp_gl/models.{Eq}

pub fn from_equals(equals: fn(a, a) -> Bool) -> Eq(a) {
  Eq(equals)
}

// -------------------------------------------------------------------------------------
// primitives
// -------------------------------------------------------------------------------------

pub fn generic() -> Eq(a) {
  Eq(fn(a: a, b: a) { a == b })
}

pub fn int() -> Eq(Int) {
  Eq(fn(a: Int, b: Int) { a == b })
}

pub fn float() -> Eq(Float) {
  Eq(fn(a: Float, b: Float) { a == b })
}

pub fn string() -> Eq(String) {
  Eq(fn(a: String, b: String) { a == b })
}

pub fn bool() -> Eq(Bool) {
  Eq(fn(a: Bool, b: Bool) { a == b })
}
