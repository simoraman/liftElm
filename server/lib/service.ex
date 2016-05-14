defmodule MongoPool do
  use Mongo.Pool, name: __MODULE__, adapter: Mongo.Pool.Poolboy
end

defmodule WorkoutService do
  def insert(lifts) do
    workout = Workout.to_mongo_map(lifts)
    Mongo.insert_one(MongoPool, "testCollection", workout)
  end

  def get do
    result = Mongo.find(MongoPool, "testCollection", %{}, limit: 20)
    result_map = Enum.to_list(result)
    Enum.map(result_map, fn x -> Workout.from_mongo_map(x) end )
  end
end
