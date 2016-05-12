defmodule Server.Router do 
 use Plug.Router
  
  if Mix.env == :dev do
    use Plug.Debugger
  end

  plug :match
  plug :dispatch

  post "/api/workout" do
    {:ok, data, _} = Plug.Conn.read_body(conn)
    lifts = Poison.decode!(data, as: %{"sets" => [LiftSet]})["sets"]
    WorkoutService.insert(lifts)
    send_resp(conn, 201, "Created!")
  end
end
