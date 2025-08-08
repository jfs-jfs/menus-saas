import app/database_setup
import app/di
import app/router
import dot_env/env
import gleam/erlang/process
import gleam/result
import mist
import wisp
import wisp/wisp_mist

pub fn start() -> Result(Nil, String) {
  wisp.configure_logger()
  use wisp_secret <- result.try(env.get_string("WISP_SECRET"))
  use _ <- result.try(database_setup.setup())

  let dependencies = di.build()

  let assert Ok(_) =
    wisp_mist.handler(router.handle_request(dependencies, _), wisp_secret)
    |> mist.new
    |> mist.port(env.get_int_or("PORT", 8081))
    |> mist.start

  process.sleep_forever() |> Ok()
}
