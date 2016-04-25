import Html exposing (h1, img, div, button, text, input, label)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import StartApp as StartApp
import Effects exposing (Effects, Never)
import Maybe exposing (map)

app = StartApp.start { init = (emptyModel, Effects.none), view = view, update = update, inputs = [] }
main = app.html
type alias Set = { id: Int, lift: String, reps: Int, weight: Float}

emptySet id = { id = id, lift = "", reps = 0, weight = 0 }
emptyModel = { lifts = [], newSet = (emptySet 0), nextId = 1 }

type Action = Insert Set

update action model = 
  case action of 
    Insert set -> ({model | lifts = ([set] ++ model.lifts), nextId = model.nextId + 1}, Effects.none)
  
liftTemplate: Set -> List Html.Html
liftTemplate set = 
  [  
    div [] [
      text (toString set.id), 
      label [] [ text "Lift: ", input [value set.lift ] [] ], 
      label [] [ text "Reps: ", input [value (toString set.reps)] [] ], 
      label [] [ text "Weight: ", input [value (toString set.weight)] [] ] 
    ]
  ]
newSetTemplate address model = 
    button [onClick address (Insert (emptySet model.nextId))] [ text "+" ] 
  

view address model = 
  div [] ([
    h1[] [
      img [src "asset/bicep.png", align "middle"] [], 
      text "liftElm", 
      img [src "asset/bicep2.png", align "middle"] []]]
    ++ [newSetTemplate address model] 
    ++ (List.concatMap liftTemplate model.lifts))