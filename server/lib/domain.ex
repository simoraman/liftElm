defmodule LiftSet do
  @derive [Poison.Encoder]
  defstruct [:name, :weight, :reps]
end

defmodule Workout do
  defstruct [:lifts]

  def to_mongo_map(lifts) do
    lifts_str = Enum.map(lifts, fn x -> %{"name"=>x.name, "weight"=>x.weight, "reps"=>x.reps} end)
    %{"lifts" => lifts_str}
  end

  def from_mongo_map(workoutMap) do
    lifts_map = workoutMap["lifts"]
    lifts = Enum.map(lifts_map, fn x -> %LiftSet{name: x["name"], weight: x["weight"], reps: x["reps"]} end)
    %Workout{lifts: lifts}
  end
end
