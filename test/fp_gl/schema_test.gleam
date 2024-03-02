import gleeunit
import gleeunit/should
import fp_gl/defunc.{Defunc1, Defunc2}
import fp_gl/schema
import fp_gl/eq
import gleam/json
import gleam/dynamic
import gleam/result
import gleam/option.{type Option, None, Some}

pub fn main() {
  gleeunit.main()
}

type Literal {
  Literal(value: Int)
}

fn literal_defunc() {
  Defunc1(Literal, fn(l) { #(l.value) }, #("value"))
}

fn literal_schema() {
  schema.struct1(literal_defunc(), schema.int())
}

pub fn defunc1_literal_test() {
  let str = "{\"value\":123}"
  let v = Literal(123)

  let assert True = literal_schema().equals(v, v)
  let assert Ok(dyn) = json.decode(str, dynamic.dynamic)
  let assert Ok(decoded) = literal_schema().from_json(dyn)

  decoded
  |> should.equal(v)

  v
  |> literal_schema().to_json()
  |> json.to_string()
  |> should.equal(str)
}

type Listed {
  Listed(value: List(Int), value2: Option(Int))
}

fn listed_defunc() {
  Defunc2(Listed, fn(l) { #(l.value, l.value2) }, #("value", "value2"))
}

fn listed_schema() {
  schema.struct2(
    listed_defunc(),
    schema.list(schema.int()),
    schema.option(schema.int()),
  )
}

pub fn defunc1_listed_test() {
  let str = "{\"value\":[123],\"value2\":null}"
  let v = Listed([123], None)

  let assert Ok(dyn) = json.decode(str, dynamic.dynamic)
  let assert Ok(decoded) = listed_schema().from_json(dyn)

  decoded
  |> should.equal(v)

  v
  |> listed_schema().to_json()
  |> json.to_string()
  |> should.equal(str)
}

pub fn schema1_listed2_test() {
  let str = "{\"value\":[123],\"value2\":456}"
  let v = Listed([123], Some(456))

  let v2 = Listed([1234], Some(456))

  let assert True = listed_schema().equals(v, v)
  let assert False = listed_schema().equals(v, v2)

  let assert Ok(dyn) = json.decode(str, dynamic.dynamic)
  let assert Ok(decoded) = listed_schema().from_json(dyn)

  decoded
  |> should.equal(v)

  v
  |> listed_schema().to_json()
  |> json.to_string()
  |> should.equal(str)
}

type Wrapper {
  Wrapper(lit: Literal)
}

fn wrapper_defunc() {
  Defunc1(Wrapper, fn(w) { #(w.lit) }, #("lit"))
}

fn wrapper_schema() {
  schema.struct1(wrapper_defunc(), literal_schema())
}

pub fn defunc1_wrapper_test() {
  let str = "{\"lit\":{\"value\":123}}"
  let v = Wrapper(Literal(123))

  let assert Ok(dyn) = json.decode(str, dynamic.dynamic)
  let assert Ok(decoded) = wrapper_schema().from_json(dyn)

  decoded
  |> should.equal(v)

  v
  |> wrapper_schema().to_json()
  |> json.to_string()
  |> should.equal(str)
}

fn big_int_schema() {
  schema.Schema(
    json.int,
    fn(str) {
      use i <- result.try(dynamic.int(str))
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

  let assert Ok(dyn) = json.decode(str, dynamic.dynamic)
  let assert Ok(decoded) = big_int_schema().from_json(dyn)

  decoded
  |> should.equal(123)

  let str = "1"
  let assert Ok(dyn) = json.decode(str, dynamic.dynamic)

  dyn
  |> big_int_schema().from_json()
  |> result.is_error()
  |> should.equal(True)
}
