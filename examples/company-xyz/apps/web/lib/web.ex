defmodule CompanyXyz.Web do
  use Application
  import Plug.Adapters.Cowboy, only: [child_spec: 4, child_spec: 3]

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      child_spec(:http, CompanyXyz.Web.Router, [])
    ]

    opts = [strategy: :one_for_one, name: CompanyXyz.Web.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
