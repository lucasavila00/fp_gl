import fp_gl/models.{type Monoid}
import gleam/list

pub fn concat_all(m: Monoid(a)) {
  fn(ass: List(a)) { list.fold(ass, m.empty, m.concat) }
}
