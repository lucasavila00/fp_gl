import fp_gl/models.{type Eq, type Ord}
import gleam/list

pub fn get_eq(e: Eq(a)) -> Eq(List(a)) {
  fn(x, y) {
    list.length(x) == list.length(y)
    && list.zip(x, y)
    |> list.all(fn(t) {
      let #(x, y) = t
      e(x, y)
    })
  }
}

pub fn sort(o: Ord(a)) {
  fn(lst: List(a)) -> List(a) {
    lst
    |> list.sort(o.compare)
  }
}
