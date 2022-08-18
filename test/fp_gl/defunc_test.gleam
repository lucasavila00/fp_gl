import gleeunit
import gleeunit/should
import fp_gl/defunc.{Defunc1, Defunc2}
import fp_gl/models.{Ord}
import fp_gl/semigroup
import gleam/int

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
      assert Literal(value) = literal
      #(value)
    },
    #("value"),
  )
}

type Expression {
  Expression(first: Int, second: Int)
}

fn expression_defunc() {
  Defunc2(
    Expression,
    fn(expression) {
      assert Expression(first, second) = expression
      #(first, second)
    },
    #("first", "second"),
  )
}

pub fn defunc1_test() {
  let max_int = semigroup.max(Ord(int.compare))
  let semi = semigroup.struct1(literal_defunc(), max_int)

  let v1 = Literal(1)
  let v2 = Literal(2)

  semi.concat(v1, v2)
  |> should.equal(Literal(2))
}

pub fn defunc2_test() {
  let max_int = semigroup.max(Ord(int.compare))
  let min_int = semigroup.min(Ord(int.compare))
  let semi = semigroup.struct2(expression_defunc(), min_int, max_int)

  let v1 = Expression(1, 1)
  let v2 = Expression(2, 2)

  semi.concat(v1, v2)
  |> should.equal(Expression(1, 2))
}
