defmodule HelloWorldPlug.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    conn
      |> Plug.Conn.send_resp(200, "Hello world!")
  end
end
