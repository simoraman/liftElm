import Html exposing (h1, img, div, button, text, input, label)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, on, targetValue)
import StartApp as StartApp
import Effects exposing (Effects, Never)
import Maybe exposing (map)
import String exposing (..)

app = StartApp.start { init = (emptyModel, Effects.none), view = view, update = update, inputs = [] }

main = app.html

type alias Set = 
  { id: Int
  , lift: String
  , reps: Int
  , weight: Float}

emptySet id = 
  { id = id
  , lift = ""
  , reps = 0
  , weight = 0 }

emptyModel = 
  { lifts = []
  , newSet = (emptySet 0)
  , nextId = 1 }

type Action 
  = NoOp 
  | Insert Set 
  | UpdateLift Int String
  | UpdateWeight Int Float
  | UpdateReps Int Int

updateLiftName model id name = 
  let
    updatedLifts = model.lifts 
      |> List.map (\l -> if l.id == id then {l | lift = name} else l) 
  in
    { model | lifts = updatedLifts } 

updateLiftWeight model id weight = 
  let
    updatedLifts = model.lifts 
      |> List.map (\l -> if l.id == id then {l | weight = weight} else l) 
  in
    { model | lifts = updatedLifts } 

updateLiftReps model id reps = 
  let
    updatedLifts = model.lifts 
      |> List.map (\l -> if l.id == id then {l | reps = reps} else l) 
  in
    { model | lifts = updatedLifts } 
    
update action model = 
  case action of 
    Insert set -> ({model | lifts = ([set] ++ model.lifts), nextId = model.nextId + 1}, Effects.none)
    UpdateLift id str -> (updateLiftName model id str, Effects.none)
    UpdateWeight id weight -> (updateLiftWeight model id weight, Effects.none)
    UpdateReps id reps -> (updateLiftReps model id reps, Effects.none)
    _ -> (model, Effects.none)
    
toIntAction action str =
  case String.toInt str of 
    Result.Ok i -> action i
    _ -> NoOp 
 
toFloatAction action str =
  case String.toFloat str of 
    Result.Ok i -> action i
    _ -> NoOp
         
liftTemplate: Signal.Address Action -> Set -> List Html.Html
liftTemplate address set = 
  [ div [] 
    [ text (toString set.id)
    , label [] 
        [ text "Lift: "
        , input [value set.lift
        , on "input" targetValue (\str -> Signal.message address (UpdateLift set.id str))] [] ]
    , label [] 
        [ text "Reps: "
        , input [value (toString set.reps)
        , on "input" targetValue (\str -> Signal.message address (toIntAction (UpdateReps set.id) str))] [] ]
    , label [] 
      [ text "Weight: "
      , input [value (toString set.weight)
      , on "input" targetValue (\str -> Signal.message address (toFloatAction (UpdateWeight set.id) str))] [] ]]]
  
newSetTemplate address model = 
  let 
    lastEntry = (model.lifts |> List.head |> Maybe.withDefault (emptySet 0))
  in
    button [onClick address (Insert { lastEntry | id = model.nextId})] [ text "+" ] 

siteTitle = 
  [ h1[] 
    [ img [src "asset/bicep.png", align "middle"] []
    , text "liftElm"
    , img [src "asset/bicep2.png", align "middle"] []]]
      
view address model = 
  div [] 
    ( siteTitle 
    ++ [newSetTemplate address model] 
    ++ (List.concatMap (liftTemplate address) model.lifts))