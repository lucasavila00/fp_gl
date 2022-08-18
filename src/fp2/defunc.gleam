pub type Defunc1(t1, t) {
  Defunc1(
    constructor: fn(t1) -> t,
    destructor: fn(t) -> #(t1),
    names: #(String),
  )
}

pub type Defunc2(t1, t2, t) {
  Defunc2(
    constructor: fn(t1, t2) -> t,
    destructor: fn(t) -> #(t1, t2),
    names: #(String, String),
  )
}

pub type Defunc3(t1, t2, t3, t) {
  Defunc3(
    constructor: fn(t1, t2, t3) -> t,
    destructor: fn(t) -> #(t1, t2, t3),
    names: #(String, String, String),
  )
}
