defmodule MongoPool do
  use Mongo.Pool, name: __MODULE__, adapter: Mongo.Pool.Poolboy
end

defmodule WorkoutService do
  def insert(lifts) do
    lifts_str = Enum.map(lifts, fn x -> %{"name"=>x.name, "weight"=>x.weight, "reps"=>x.reps} end)
    
    Mongo.insert_one(MongoPool, "testCollection", %{"lifts" => lifts_str})
  end

  def get do
    result = Mongo.find(MongoPool, "testCollection", %{}, limit: 20)
    result_map = Enum.to_list(result)
    Enum.map(result_map, fn x -> Workout.from_mongo_map(x) end )
  end
end

defmodule WorkoutServiceTest do
  use ExUnit.Case

  setup do
    MongoPool.start_link(database: "test")
    Mongo.delete_many(MongoPool, "testCollection", %{})
    :ok
  end
  
  test "Insert workout" do
    lifts = [%LiftSet{name: "squat", weight: 10, reps: 1}]
    WorkoutService.insert(lifts)
    result_lifts = List.first(WorkoutService.get()).lifts
    lift = List.first(result_lifts)
    assert lift.name == "squat"
    assert lift.weight == 10
    assert lift.reps == 1
  end
end
