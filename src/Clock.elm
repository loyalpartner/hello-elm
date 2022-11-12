module Clock exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (height, width)
import Svg exposing (Svg, circle, line, svg)
import Svg.Attributes exposing (cx, cy, fill, r, stroke, strokeLinecap, strokeWidth, viewBox, x1, x2, y1, y2)
import Task
import Time



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Time.utc (Time.millisToPosix 0)
    , Cmd.batch
        [ Task.perform AdjustTimeZone Time.here
        , Task.perform Tick Time.now
        ]
    )



-- UPDATE


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 1000 Tick



-- VIEW


view : Model -> Html Msg
view model =
    let
        hour =
            toFloat (Time.toHour model.zone model.time)

        minute =
            toFloat (Time.toMinute model.zone model.time)

        second =
            toFloat (Time.toSecond model.zone model.time)
    in
    svg
        [ viewBox "0 0 400 400"
        , width 400
        , height 400
        ]
        [ circle [ cx "200", cy "200", r "120", fill "#1293d8" ] []
        , viewHandle 6 60 (hour / 12)
        , viewHandle 6 90 (minute / 60)
        , viewHandle 3 90 (second / 60)
        ]


viewHandle : Int -> Float -> Float -> Svg msg
viewHandle width length angleInTurns =
    let
        x =
            200 + length * sin (turns angleInTurns)

        y =
            200 - length * cos (turns angleInTurns)
    in
    line
        [ x1 "200"
        , y1 "200"
        , x2 (String.fromFloat x)
        , y2 (String.fromFloat y)
        , stroke "white"
        , strokeWidth (String.fromInt width)
        , strokeLinecap "round"
        ]
        []
