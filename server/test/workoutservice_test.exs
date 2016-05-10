defmodule MongoPool do
  use Mongo.Pool, name: __MODULE__, adapter: Mongo.Pool.Poolboy
end

defmodule WorkoutService do
  def insert(lifts) do
    liftsStr = Enum.map(lifts, fn x -> %{"name"=>x.name} end)
    
    Mongo.insert_one(MongoPool, "testCollection", %{"lifts" => liftsStr}) 
  end

  def get do
    res = Mongo.find(MongoPool, "testCollection", %{}, limit: 20)
    Enum.to_list(res)
  end
end

defmodule WorkoutServiceTest do
  use ExUnit.Case

  setup do
    MongoPool.start_link(database: "test")
    :ok
  end
  
  test "Insert workout" do
    workout = [%LiftSet{name: "squat", weight: 10, reps: 1}]
    WorkoutService.insert(workout)
    result = List.first(WorkoutService.get())["lifts"]
    assert List.first(result)["name"] == "squat"
  end
end
