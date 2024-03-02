import fp_gl/defunc.{type Defunc1, type Defunc2, type Defunc3}
import fp_gl/models.{type Eq}
import fp_gl/eq
import fp_gl/flist
import fp_gl/foption
import gleam/json.{type Json}
import gleam/result
import gleam/dynamic.{type DecodeErrors, type Dynamic}
import gleam/option.{type Option, None, Some}

// -------------------------------------------------------------------------------------
// models
// -------------------------------------------------------------------------------------

pub type Schema(a) {
  Schema(
    to_json: fn(a) -> Json,
    from_json: fn(Dynamic) -> Result(a, DecodeErrors),
    equals: Eq(a),
  )
}

// -------------------------------------------------------------------------------------
// primitives
// -------------------------------------------------------------------------------------

pub fn int() {
  Schema(json.int, dynamic.int, eq.int())
}

pub fn float() {
  Schema(json.float, dynamic.float, eq.float())
}

pub fn string() {
  Schema(json.string, dynamic.string, eq.string())
}

pub fn bool() {
  Schema(json.bool, dynamic.bool, eq.bool())
}

pub fn list(c: Schema(a)) -> Schema(List(a)) {
  Schema(
    fn(a) { json.array(a, c.to_json) },
    dynamic.list(c.from_json),
    flist.get_eq(c.equals),
  )
}

pub fn option(c: Schema(a)) -> Schema(Option(a)) {
  Schema(
    fn(a) {
      case a {
        None -> json.null()
        Some(val) -> c.to_json(val)
      }
    },
    dynamic.optional(c.from_json),
    foption.get_eq(c.equals),
  )
}

// -------------------------------------------------------------------------------------
// constructors
// -------------------------------------------------------------------------------------

pub fn struct1(defunc: Defunc1(t1, t), schema1: Schema(t1)) -> Schema(t) {
  Schema(
    fn(value) {
      let #(value1) = defunc.destructor(value)
      let #(name1) = defunc.names
      [#(name1, schema1.to_json(value1))]
      |> json.object()
    },
    fn(dyn) {
      let #(name1) = defunc.names
      dyn
      |> dynamic.field(name1, of: schema1.from_json)
      |> result.map(defunc.constructor)
    },
    fn(x, y) {
      let #(x_value1) = defunc.destructor(x)
      let #(y_value1) = defunc.destructor(y)
      schema1.equals(x_value1, y_value1)
    },
  )
}

pub fn struct2(
  defunc: Defunc2(t1, t2, t),
  schema1: Schema(t1),
  schema2: Schema(t2),
) -> Schema(t) {
  Schema(
    fn(value) {
      let #(value1, value2) = defunc.destructor(value)
      let #(name1, name2) = defunc.names
      [#(name1, schema1.to_json(value1)), #(name2, schema2.to_json(value2))]
      |> json.object()
    },
    fn(dyn) {
      let #(name1, name2) = defunc.names
      dyn
      |> dynamic.decode2(
        defunc.constructor,
        dynamic.field(name1, of: schema1.from_json),
        dynamic.field(name2, of: schema2.from_json),
      )
    },
    fn(x, y) {
      let #(x_value1, x_value2) = defunc.destructor(x)
      let #(y_value1, y_value2) = defunc.destructor(y)
      schema1.equals(x_value1, y_value1) && schema2.equals(x_value2, y_value2)
    },
  )
}

pub fn struct3(
  defunc: Defunc3(t1, t2, t3, t),
  schema1: Schema(t1),
  schema2: Schema(t2),
  schema3: Schema(t3),
) -> Schema(t) {
  Schema(
    fn(value) {
      let #(value1, value2, value3) = defunc.destructor(value)
      let #(name1, name2, name3) = defunc.names
      [
        #(name1, schema1.to_json(value1)),
        #(name2, schema2.to_json(value2)),
        #(name3, schema3.to_json(value3)),
      ]
      |> json.object()
    },
    fn(dyn) {
      let #(name1, name2, name3) = defunc.names
      dyn
      |> dynamic.decode3(
        defunc.constructor,
        dynamic.field(name1, of: schema1.from_json),
        dynamic.field(name2, of: schema2.from_json),
        dynamic.field(name3, of: schema3.from_json),
      )
    },
    fn(x, y) {
      let #(x_value1, x_value2, x_value3) = defunc.destructor(x)
      let #(y_value1, y_value2, y_value3) = defunc.destructor(y)
      schema1.equals(x_value1, y_value1)
      && schema2.equals(x_value2, y_value2)
      && schema3.equals(x_value3, y_value3)
    },
  )
}
// TODO tuple?
