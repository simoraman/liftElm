defmodule LiftSet do
  @derive [Poison.Encoder]
  defstruct [:name, :weight, :reps]
end
