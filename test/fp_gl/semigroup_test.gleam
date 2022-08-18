import gleeunit
import gleeunit/should
import fp_gl/defunc.{Defunc3}
import fp_gl/models.{Ord, Semigroup}
import fp_gl/semigroup
import gleam/int
import gleam/option.{None, Option, Some}

pub fn main() {
  gleeunit.main()
}

type Config {
  Config(version: Int, path: String, config: Option(Config))
}

fn config_defunc() {
  Defunc3(
    Config,
    fn(literal) {
      let Config(version, path, config) = literal
      #(version, path, config)
    },
    #("version", "path", "config"),
  )
}

fn config_semigroup() -> Semigroup(Config) {
  semigroup.struct3(
    config_defunc(),
    semigroup.max(Ord(int.compare)),
    semigroup.last(),
    Semigroup(fn(x, y) {
      case #(x, y) {
        #(Some(x), Some(y)) -> Some(config_semigroup().concat(x, y))
        #(Some(x), None) -> Some(x)
        #(None, Some(y)) -> Some(y)
        #(None, None) -> None
      }
    }),
  )
}

pub fn defunc1_test() {
  let c1 =
    Config(
      version: 3,
      path: "a",
      config: Some(Config(version: 2, path: "c", config: None)),
    )
  let c2 =
    Config(
      version: 1,
      path: "b",
      config: Some(Config(version: 1, path: "b", config: None)),
    )

  config_semigroup().concat(c1, c2)
  |> should.equal(Config(
    version: 3,
    path: "b",
    config: Some(Config(version: 2, path: "b", config: None)),
  ))
}
