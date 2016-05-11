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
