defmodule Server.Router do 
 use Plug.Router
  
  if Mix.env == :dev do
    use Plug.Debugger
  end
  
  plug Plug.Static, at: "/", from: "../public"
  plug :match
  plug :dispatch
  plug :not_found

  post "/api/workout" do
    {:ok, data, _} = Plug.Conn.read_body(conn)
    lifts = Poison.decode!(data, as: %{"sets" => [LiftSet]})["sets"]
    WorkoutService.insert(lifts)
    send_resp(conn, 201, "Created!")
  end

  get "/api/workout" do
    workouts = WorkoutService.get()
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(workouts))
  end

   def not_found(conn, _) do
    send_resp(conn, 404, "not found")
  end
end
