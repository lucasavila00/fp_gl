import fp2/models.{Monoid}
import gleam/string

pub fn monoid() {
  Monoid(fn(a: String, b: String) { string.concat([a, b]) }, "")
}
