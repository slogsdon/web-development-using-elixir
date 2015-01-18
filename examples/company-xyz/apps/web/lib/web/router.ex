defmodule CompanyXyz.Web.Router do
  use Plug.Router

  use Plug.Debugger, otp_app: :web
  plug Plug.Static, at: "/static", from: :web
  plug :match
  plug :dispatch

  get "/" do
    conn |> send_resp(200, index_body)
  end

  get "/contact" do
    conn |> send_resp(200, contact_body)
  end

  post "/contact" do
    conn |> send_resp(200, contact_success_body)
  end

  match _ do
    conn |> send_resp
  end

  defp index_body do
    """
    <!doctype html>
    <html>
    <head>
      <title>Company XYZ</title>
    </head>
    <body>
      <h1>Company XYZ welcomes you!</h1>
      <a href="/contact">Contact Us</a>
    </body>
    </html>
    """
  end

  defp contact_body do
    """
    <!doctype html>
    <html>
    <head>
      <title>Company XYZ</title>
    </head>
    <body>
      <h1>Contact Company XYZ</h1>
      <form method="post" action="/contact">
        <input type="text" name="name" placeholder="Your Name" />
        <input type="submit" value="Submit" />
      </form>
      <a href="/">Home</a>
    </body>
    </html>
    """
  end

  defp contact_success_body do
    """
    <!doctype html>
    <html>
    <head>
      <title>Company XYZ</title>
    </head>
    <body>
      <h1>Thanks for contacting us!</h1>
      <a href="/">Home</a>
    </body>
    </html>
    """
  end
end
