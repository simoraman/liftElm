module LiftApp exposing (..)
import Platform.Cmd as Cmd exposing (Cmd)
import Html.App as Html
import Html exposing (h1, img, div, button, text, input, label)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, on, targetValue, onInput)
import String exposing (..)

main = Html.program { init = (emptyModel, Cmd.none)
                    , update = update
                    , view = view
                    , subscriptions = \_ -> Sub.none }

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

type Msg 
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
    
update msg model = 
  case msg of 
    Insert set -> ({model | lifts = ([set] ++ model.lifts), nextId = model.nextId + 1}, Cmd.none)
    UpdateLift id str -> (updateLiftName model id str, Cmd.none)
    UpdateWeight id weight -> (updateLiftWeight model id weight, Cmd.none)
    UpdateReps id reps -> (updateLiftReps model id reps, Cmd.none)
    _ -> (model, Cmd.none)
    
toIntAction action str =
  case String.toInt str of 
    Result.Ok i -> action i
    _ -> NoOp 
 
toFloatAction action str =
  case String.toFloat str of 
    Result.Ok i -> action i
    _ -> NoOp
         
liftTemplate set = 
  [ div [] 
    [ text (toString set.id)
    , label [] 
        [ text "Lift: "
        , input [value set.lift
        , onInput (\str -> UpdateLift set.id str)] [] ]
    , label [] 
        [ text "Reps: "
        , input [value (toString set.reps)
        , onInput (\str -> toIntAction (UpdateReps set.id) str)] [] ]
    , label [] 
      [ text "Weight: "
      , input [value (toString set.weight)
      , onInput (\str -> toFloatAction (UpdateWeight set.id) str)] [] ]
    ]]
  
newSetTemplate model = 
  let 
    lastEntry = (model.lifts |> List.head |> Maybe.withDefault (emptySet 0))
  in
    button [onClick (Insert { lastEntry | id = model.nextId})] [ text "+" ] 

siteTitle = 
  [ h1[] 
    [ img [src "asset/bicep.png", align "middle"] []
    , text "liftElm"
    , img [src "asset/bicep2.png", align "middle"] []]]
      
view model = 
  div [] 
    ( siteTitle 
    ++ [newSetTemplate model] 
    ++ (List.concatMap (liftTemplate) model.lifts))
