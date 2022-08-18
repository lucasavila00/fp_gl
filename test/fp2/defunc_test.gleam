import gleeunit
import gleeunit/should
import fp2/defunc.{Defunc1, Defunc2}
import fp2/ord.{Ord}
import fp2/semigroup
import gleam/int

pub fn main() {
  gleeunit.main()
}

type Ast {
  Expression(first: Int, second: Int)
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

fn expression_hkt() {
  Defunc2(
    Expression,
    fn(expression) {
      assert Expression(first, second) = expression
      #(first, second)
    },
    #("first", "second"),
  )
}

pub fn hkt1_test() {
  let max_int = semigroup.max(Ord(int.compare))
  let semi = semigroup.struct1(literal_hkt(), max_int)

  let v1 = Literal(1)
  let v2 = Literal(2)

  semi.concat(v1, v2)
  |> should.equal(Literal(2))
}

pub fn hkt2_test() {
  let max_int = semigroup.max(Ord(int.compare))
  let min_int = semigroup.min(Ord(int.compare))
  let semi = semigroup.struct2(expression_hkt(), min_int, max_int)

  let v1 = Expression(1, 1)
  let v2 = Expression(2, 2)

  semi.concat(v1, v2)
  |> should.equal(Expression(1, 2))
}
