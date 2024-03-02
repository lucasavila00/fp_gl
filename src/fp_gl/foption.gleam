import fp_gl/models.{type Eq}
import gleam/option.{type Option, None, Some}

pub fn get_eq(e: Eq(a)) -> Eq(Option(a)) {
  fn(x, y) {
    case #(x, y) {
      #(Some(x), Some(y)) -> e(x, y)
      #(None, None) -> True
      _ -> False
    }
  }
}
