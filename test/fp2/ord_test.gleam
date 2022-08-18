import gleeunit
import gleeunit/should
import fp2/models.{Ord}
import fp2/monoid
import fp2/ord
import fp2/flist
import gleam/int
import gleam/string

pub fn main() {
  gleeunit.main()
}

pub fn ord_get_monoid_test() {
  let ord_fst =
    Ord(fn(a: #(Int, String), b: #(Int, String)) { int.compare(a.0, b.0) })

  let ord_snd =
    Ord(fn(a: #(Int, String), b: #(Int, String)) { string.compare(a.1, b.1) })

  let m = ord.get_monoid()

  let tuples = [
    //
    #(2, "c"),
    #(1, "b"),
    #(2, "a"),
    #(1, "c"),
  ]

  let o1 =
    [m.empty, ord_fst, ord_snd]
    |> monoid.concat_all(m)

  tuples
  |> flist.sort(o1)
  |> should.equal([
    // 
    #(1, "b"),
    #(1, "c"),
    #(2, "a"),
    #(2, "c"),
  ])

  let o2 =
    [m.empty, ord_snd, ord_fst]
    |> monoid.concat_all(m)
  tuples
  |> flist.sort(o2)
  |> should.equal([
    // 
    #(2, "a"),
    #(1, "b"),
    #(1, "c"),
    #(2, "c"),
  ])
}
