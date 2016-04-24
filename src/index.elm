import Html exposing (div, button, text, input, label)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import StartApp as StartApp
import Effects exposing (Effects, Never)
import Maybe exposing (map)

app = StartApp.start { init = (model, Effects.none), view = view, update = update, inputs = [] }
main = app.html
type alias Set = { lift: String, reps: Int, weight: Float}
model: List Set
model = [{lift = "Squat", reps = 5, weight = 50}, {lift = "Bench", reps = 5, weight = 50}]
update a m = (m, a)

liftTemplate: Set -> List Html.Html
liftTemplate set = 
  [ text set.lift, 
    div [] [ 
      label [] [ text "Reps", input [value (toString set.reps)] [] ], 
      label [] [ text "Weight", input [value (toString set.weight)] [] ] 
    ]
  ]
view x model = 
  div [] (List.concatMap liftTemplate model)