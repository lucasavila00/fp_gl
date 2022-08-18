import gleeunit
import gleeunit/should
import fp_gl/defunc.{Defunc1, Defunc2}
import fp_gl/codec
import fp_gl/eq
import gleam/json
import gleam/dynamic
import gleam/result
import gleam/option.{None, Option, Some}

pub fn main() {
  gleeunit.main()
}

type Literal {
  Literal(value: Int)
}

fn literal_defunc() {
  Defunc1(
    Literal,
    fn(literal) {
      let Literal(value) = literal
      #(value)
    },
    #("value"),
  )
}

fn literal_codec() {
  codec.codec1(literal_defunc(), codec.int())
}

pub fn defunc1_literal_test() {
  let str = "{\"value\":123}"
  let v = Literal(123)

  assert Ok(dyn) = json.decode(str, dynamic.dynamic)
  assert Ok(decoded) = literal_codec().from_json(dyn)

  decoded
  |> should.equal(v)

  v
  |> literal_codec().to_json()
  |> json.to_string()
  |> should.equal(str)
}

type Listed {
  Listed(value: List(Int), value2: Option(Int))
}

fn listed_defunc() {
  Defunc2(
    Listed,
    fn(listed) {
      let Listed(value, value2) = listed
      #(value, value2)
    },
    #("value", "value2"),
  )
}

fn listed_codec() {
  codec.codec2(
    listed_defunc(),
    codec.list(codec.int()),
    codec.option(codec.int()),
  )
}

pub fn defunc1_listed_test() {
  let str = "{\"value\":[123],\"value2\":null}"
  let v = Listed([123], None)

  assert Ok(dyn) = json.decode(str, dynamic.dynamic)
  assert Ok(decoded) = listed_codec().from_json(dyn)

  decoded
  |> should.equal(v)

  v
  |> listed_codec().to_json()
  |> json.to_string()
  |> should.equal(str)
}

pub fn defunc1_listed2_test() {
  let str = "{\"value\":[123],\"value2\":456}"
  let v = Listed([123], Some(456))

  assert Ok(dyn) = json.decode(str, dynamic.dynamic)
  assert Ok(decoded) = listed_codec().from_json(dyn)

  decoded
  |> should.equal(v)

  v
  |> listed_codec().to_json()
  |> json.to_string()
  |> should.equal(str)
}

type Wrapper {
  Wrapper(lit: Literal)
}

fn wrapper_defunc() {
  Defunc1(
    Wrapper,
    fn(w) {
      let Wrapper(lit) = w
      #(lit)
    },
    #("lit"),
  )
}

fn wrapper_codec() {
  codec.codec1(wrapper_defunc(), literal_codec())
}

pub fn defunc1_wrapper_test() {
  let str = "{\"lit\":{\"value\":123}}"
  let v = Wrapper(Literal(123))

  assert Ok(dyn) = json.decode(str, dynamic.dynamic)
  assert Ok(decoded) = wrapper_codec().from_json(dyn)

  decoded
  |> should.equal(v)

  v
  |> wrapper_codec().to_json()
  |> json.to_string()
  |> should.equal(str)
}

fn big_int_codec() {
  codec.Codec(
    json.int,
    fn(str) {
      try i = dynamic.int(str)
      case i > 100 {
        True -> Ok(i)
        False -> Error([])
      }
    },
    eq.int(),
  )
}

pub fn defunc1_big_literal_test() {
  let str = "123"

  assert Ok(dyn) = json.decode(str, dynamic.dynamic)
  assert Ok(decoded) = big_int_codec().from_json(dyn)

  decoded
  |> should.equal(123)

  let str = "1"
  assert Ok(dyn) = json.decode(str, dynamic.dynamic)

  dyn
  |> big_int_codec().from_json()
  |> result.is_error()
  |> should.equal(True)
}
