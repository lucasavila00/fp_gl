import gleeunit
import gleeunit/should
import fp2/defunc.{Defunc1}
import fp2/codec
import gleam/json
import gleam/dynamic
import gleam/result

pub fn main() {
  gleeunit.main()
}

type Literal {
  Literal(value: Int)
}

fn literal_hkt() {
  Defunc1(
    Literal,
    fn(literal) {
      assert Literal(value) = literal
      #(value)
    },
    #("value"),
  )
}

fn literal_codec() {
  codec.codec1(literal_hkt(), codec.int())
}

type Wrapper {
  Wrapper(lit: Literal)
}

fn wrapper_hkt() {
  Defunc1(
    Wrapper,
    fn(w) {
      assert Wrapper(lit) = w
      #(lit)
    },
    #("lit"),
  )
}

pub fn hkt1_literal_test() {
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

pub fn hkt1_wrapper_test() {
  let wrapper_codec = codec.codec1(wrapper_hkt(), literal_codec())
  let str = "{\"lit\":{\"value\":123}}"
  let v = Wrapper(Literal(123))

  assert Ok(dyn) = json.decode(str, dynamic.dynamic)
  assert Ok(decoded) = wrapper_codec.from_json(dyn)

  decoded
  |> should.equal(v)

  v
  |> wrapper_codec.to_json()
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
  )
}

pub fn hkt1_big_literal_test() {
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