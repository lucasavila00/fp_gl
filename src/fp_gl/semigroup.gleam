import gleam/list
import fp_gl/models.{type Ord, type Semigroup, Semigroup}
import fp_gl/defunc.{type Defunc1, type Defunc2, type Defunc3}
import fp_gl/ord

// -------------------------------------------------------------------------------------
// combinators
// -------------------------------------------------------------------------------------

pub fn reverse(s: Semigroup(a)) -> Semigroup(a) {
  Semigroup(fn(x, y) { s.concat(y, x) })
}

pub fn intercalate(middle: a) {
  fn(s: Semigroup(a)) -> Semigroup(a) {
    Semigroup(fn(x, y) { s.concat(x, s.concat(middle, y)) })
  }
}

pub fn struct1(
  defunc: Defunc1(t1, t),
  semigroup1: Semigroup(t1),
) -> Semigroup(t) {
  Semigroup(fn(x: t, y: t) {
    let x = defunc.destructor(x)
    let y = defunc.destructor(y)
    defunc.constructor(semigroup1.concat(x.0, y.0))
  })
}

pub fn struct2(
  defunc: Defunc2(t1, t2, t),
  semigroup1: Semigroup(t1),
  semigroup2: Semigroup(t2),
) -> Semigroup(t) {
  Semigroup(fn(x: t, y: t) {
    let x = defunc.destructor(x)
    let y = defunc.destructor(y)
    defunc.constructor(semigroup1.concat(x.0, y.0), semigroup2.concat(x.1, y.1))
  })
}

pub fn struct3(
  defunc: Defunc3(t1, t2, t3, t),
  semigroup1: Semigroup(t1),
  semigroup2: Semigroup(t2),
  semigroup3: Semigroup(t3),
) -> Semigroup(t) {
  Semigroup(fn(x: t, y: t) {
    let x = defunc.destructor(x)
    let y = defunc.destructor(y)
    defunc.constructor(
      semigroup1.concat(x.0, y.0),
      semigroup2.concat(x.1, y.1),
      semigroup3.concat(x.2, y.2),
    )
  })
}

pub fn tuple1(semigroup1: Semigroup(a)) -> Semigroup(#(a)) {
  Semigroup(fn(x: #(a), y: #(a)) { #(semigroup1.concat(x.0, y.0)) })
}

pub fn tuple2(
  semigroup1: Semigroup(a),
  semigroup2: Semigroup(b),
) -> Semigroup(#(a, b)) {
  Semigroup(fn(x: #(a, b), y: #(a, b)) {
    #(semigroup1.concat(x.0, y.0), semigroup2.concat(x.1, y.1))
  })
}

pub fn tuple3(
  semigroup1: Semigroup(a),
  semigroup2: Semigroup(b),
  semigroup3: Semigroup(c),
) -> Semigroup(#(a, b, c)) {
  Semigroup(fn(x: #(a, b, c), y: #(a, b, c)) {
    #(
      semigroup1.concat(x.0, y.0),
      semigroup2.concat(x.1, y.1),
      semigroup3.concat(x.2, y.2),
    )
  })
}

// -------------------------------------------------------------------------------------
// constructors
// -------------------------------------------------------------------------------------

pub fn min(o: Ord(a)) -> Semigroup(a) {
  Semigroup(ord.min(o))
}

pub fn max(o: Ord(a)) -> Semigroup(a) {
  Semigroup(ord.max(o))
}

pub fn constant(it: a) -> Semigroup(a) {
  Semigroup(concat: fn(_, _) { it })
}

// -------------------------------------------------------------------------------------
// instances
// -------------------------------------------------------------------------------------
pub fn first() -> Semigroup(a) {
  Semigroup(concat: fn(x, _) { x })
}

pub fn last() -> Semigroup(a) {
  Semigroup(concat: fn(_, y) { y })
}

// -------------------------------------------------------------------------------------
// utils
// -------------------------------------------------------------------------------------

pub fn concat_all(m: Semigroup(a), empty: a) {
  fn(ass: List(a)) { list.fold(ass, empty, m.concat) }
}
