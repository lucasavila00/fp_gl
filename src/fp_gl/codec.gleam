import fp_gl/defunc.{Defunc1, Defunc2, Defunc3}
import fp_gl/models.{Eq}
import fp_gl/eq
import fp_gl/flist
import fp_gl/foption
import gleam/json.{Json}
import gleam/result
import gleam/dynamic.{DecodeErrors, Dynamic}
import gleam/option.{None, Option, Some}

// -------------------------------------------------------------------------------------
// models
// -------------------------------------------------------------------------------------

pub type Codec(a) {
  Codec(
    to_json: fn(a) -> Json,
    from_json: fn(Dynamic) -> Result(a, DecodeErrors),
    eq: Eq(a),
  )
}

// -------------------------------------------------------------------------------------
// primitives
// -------------------------------------------------------------------------------------

pub fn int() {
  Codec(json.int, dynamic.int, eq.int())
}

pub fn float() {
  Codec(json.float, dynamic.float, eq.float())
}

pub fn string() {
  Codec(json.string, dynamic.string, eq.string())
}

pub fn bool() {
  Codec(json.bool, dynamic.bool, eq.bool())
}

pub fn list(c: Codec(a)) -> Codec(List(a)) {
  Codec(
    fn(a) { json.array(a, c.to_json) },
    dynamic.list(c.from_json),
    flist.get_eq(c.eq),
  )
}

pub fn option(c: Codec(a)) -> Codec(Option(a)) {
  Codec(
    fn(a) {
      case a {
        None -> json.null()
        Some(val) -> c.to_json(val)
      }
    },
    dynamic.optional(c.from_json),
    foption.get_eq(c.eq),
  )
}

// -------------------------------------------------------------------------------------
// constructors
// -------------------------------------------------------------------------------------

pub fn codec1(defunc: Defunc1(t1, t), codec1: Codec(t1)) -> Codec(t) {
  Codec(
    fn(value) {
      let #(value1) = defunc.destructor(value)
      let #(name1) = defunc.names
      [#(name1, codec1.to_json(value1))]
      |> json.object()
    },
    fn(dyn) {
      let #(name1) = defunc.names
      dyn
      |> dynamic.field(name1, of: codec1.from_json)
      |> result.map(defunc.constructor)
    },
    Eq(fn(x, y) {
      let #(x_value1) = defunc.destructor(x)
      let #(y_value1) = defunc.destructor(y)
      codec1.eq.equals(x_value1, y_value1)
    }),
  )
}

pub fn codec2(
  defunc: Defunc2(t1, t2, t),
  codec1: Codec(t1),
  codec2: Codec(t2),
) -> Codec(t) {
  Codec(
    fn(value) {
      let #(value1, value2) = defunc.destructor(value)
      let #(name1, name2) = defunc.names
      [#(name1, codec1.to_json(value1)), #(name2, codec2.to_json(value2))]
      |> json.object()
    },
    fn(dyn) {
      let #(name1, name2) = defunc.names
      dyn
      |> dynamic.decode2(
        defunc.constructor,
        dynamic.field(name1, of: codec1.from_json),
        dynamic.field(name2, of: codec2.from_json),
      )
    },
    Eq(fn(x, y) {
      let #(x_value1, x_value2) = defunc.destructor(x)
      let #(y_value1, y_value2) = defunc.destructor(y)
      codec1.eq.equals(x_value1, y_value1) && codec2.eq.equals(
        x_value2,
        y_value2,
      )
    }),
  )
}

pub fn codec3(
  defunc: Defunc3(t1, t2, t3, t),
  codec1: Codec(t1),
  codec2: Codec(t2),
  codec3: Codec(t3),
) -> Codec(t) {
  Codec(
    fn(value) {
      let #(value1, value2, value3) = defunc.destructor(value)
      let #(name1, name2, name3) = defunc.names
      [
        #(name1, codec1.to_json(value1)),
        #(name2, codec2.to_json(value2)),
        #(name3, codec3.to_json(value3)),
      ]
      |> json.object()
    },
    fn(dyn) {
      let #(name1, name2, name3) = defunc.names
      dyn
      |> dynamic.decode3(
        defunc.constructor,
        dynamic.field(name1, of: codec1.from_json),
        dynamic.field(name2, of: codec2.from_json),
        dynamic.field(name3, of: codec3.from_json),
      )
    },
    Eq(fn(x, y) {
      let #(x_value1, x_value2, x_value3) = defunc.destructor(x)
      let #(y_value1, y_value2, y_value3) = defunc.destructor(y)
      codec1.eq.equals(x_value1, y_value1) && codec2.eq.equals(
        x_value2,
        y_value2,
      ) && codec3.eq.equals(x_value3, y_value3)
    }),
  )
}
