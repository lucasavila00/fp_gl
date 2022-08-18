import fp2/defunc.{Defunc1, Defunc2, Defunc3}
import gleam/json.{Json}
import gleam/result
import gleam/dynamic.{DecodeErrors, Dynamic}

// -------------------------------------------------------------------------------------
// models
// -------------------------------------------------------------------------------------

pub type Codec(a) {
  Codec(
    to_json: fn(a) -> Json,
    from_json: fn(Dynamic) -> Result(a, DecodeErrors),
  )
}

// -------------------------------------------------------------------------------------
// primitives
// -------------------------------------------------------------------------------------

pub fn int() {
  Codec(json.int, dynamic.int)
}

pub fn float() {
  Codec(json.float, dynamic.float)
}

pub fn string() {
  Codec(json.string, dynamic.string)
}

pub fn bool() {
  Codec(json.bool, dynamic.bool)
}

// -------------------------------------------------------------------------------------
// constructors
// -------------------------------------------------------------------------------------

pub fn codec1(defunc: Defunc1(t1, t), codec1: Codec(t1)) -> Codec(t) {
  Codec(
    fn(value) {
      let value = defunc.destructor(value)
      let #(name1) = defunc.names
      [#(name1, codec1.to_json(value.0))]
      |> json.object()
    },
    fn(dyn) {
      let #(name1) = defunc.names
      dyn
      |> dynamic.field(name1, of: codec1.from_json)
      |> result.map(defunc.constructor)
    },
  )
}

pub fn codec2(
  defunc: Defunc2(t1, t2, t),
  codec1: Codec(t1),
  codec2: Codec(t2),
) -> Codec(t) {
  Codec(
    fn(value) {
      let value = defunc.destructor(value)
      let #(name1, name2) = defunc.names
      [#(name1, codec1.to_json(value.0)), #(name2, codec2.to_json(value.1))]
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
      let value = defunc.destructor(value)
      let #(name1, name2, name3) = defunc.names
      [
        #(name1, codec1.to_json(value.0)),
        #(name2, codec2.to_json(value.1)),
        #(name3, codec3.to_json(value.2)),
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
  )
}
