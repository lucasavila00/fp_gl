import fp2/defunc.{Defunc1}
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

// -------------------------------------------------------------------------------------
// constructors
// -------------------------------------------------------------------------------------

pub fn codec1(hkt: Defunc1(t1, t), codec1: Codec(t1)) -> Codec(t) {
  Codec(
    fn(value) {
      let value = hkt.destructor(value)
      let #(name_1) = hkt.names
      [#(name_1, codec1.to_json(value.0))]
      |> json.object()
    },
    fn(dyn) {
      let #(name_1) = hkt.names
      dyn
      |> dynamic.field(name_1, of: codec1.from_json)
      |> result.map(hkt.constructor)
    },
  )
}
