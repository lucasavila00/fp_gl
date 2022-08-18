import fp_gl/models.{Eq}
import gleam/option.{None, Option, Some}

pub fn get_eq(e: Eq(a)) -> Eq(Option(a)) {
  fn(x, y) {
    case #(x, y) {
      #(Some(x), Some(y)) -> e(x, y)
      #(None, None) -> True
      _ -> False
    }
  }
}
