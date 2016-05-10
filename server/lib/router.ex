
defmodule LiftSet do
  @derive [Poison.Encoder]
  defstruct [:name, :weight, :reps]
end

defmodule Server.Router do 
 use Plug.Router
  
  if Mix.env == :dev do
    use Plug.Debugger
  end

  plug :match
  plug :dispatch

  # Root path
  get "/" do
    send_resp(conn, 200, "This entire website runs on Elixir plugs!")
  end
  
  post "/api/workout" do
    {:ok, data, _} = Plug.Conn.read_body(conn)
    lifts = Poison.decode!(data, as: %{"lifts" => [LiftSet]})
    send_resp(conn, 201, "lulz")
  end
end
