import Html exposing (div, button, text, input, label)
import Html.Events exposing (onClick)
import StartApp as StartApp
import Effects exposing (Effects, Never)

app = StartApp.start { init = (model, Effects.none), view = view, update = update, inputs = [] }
main = app.html
type alias Set = { lift: String, reps: Int, weight: Float}
model: List Set
model = []
update a m = (m, a)

view x model = 
  div [] 
    [ text "Squat", 
      div [] [ 
        label [] [ text "Reps", input [] [] ], 
        label [] [ text "Weight", input [] [] ] 
      ]
    ]
