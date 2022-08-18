import gleam/list
import fp2/ord.{Ord}
import fp2/defunc.{Defunc1, Defunc2}

// -------------------------------------------------------------------------------------
// model
// -------------------------------------------------------------------------------------
pub type Semigroup(a) {
  Semigroup(concat: fn(a, a) -> a)
}

// -------------------------------------------------------------------------------------
// combinators
// -------------------------------------------------------------------------------------

pub fn struct1(hkt: Defunc1(t1, t), semigroup1: Semigroup(t1)) -> Semigroup(t) {
  Semigroup(fn(x: t, y: t) {
    let x = hkt.destructor(x)
    let y = hkt.destructor(y)
    hkt.constructor(semigroup1.concat(x.0, y.0))
  })
}

pub fn struct2(
  hkt: Defunc2(t1, t2, t),
  semigroup1: Semigroup(t1),
  semigroup2: Semigroup(t2),
) -> Semigroup(t) {
  Semigroup(fn(x: t, y: t) {
    let x = hkt.destructor(x)
    let y = hkt.destructor(y)
    hkt.constructor(semigroup1.concat(x.0, y.0), semigroup2.concat(x.1, y.1))
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

pub fn tuple4(
  semigroup1: Semigroup(a),
  semigroup2: Semigroup(b),
  semigroup3: Semigroup(c),
  semigroup4: Semigroup(d),
) -> Semigroup(#(a, b, c, d)) {
  Semigroup(fn(x: #(a, b, c, d), y: #(a, b, c, d)) {
    #(
      semigroup1.concat(x.0, y.0),
      semigroup2.concat(x.1, y.1),
      semigroup3.concat(x.2, y.2),
      semigroup4.concat(x.3, y.3),
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
