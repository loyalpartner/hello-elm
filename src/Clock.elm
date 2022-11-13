module Clock exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (height, width)
import Svg exposing (Svg, circle, line, svg)
import Svg.Attributes as A exposing (cx, cy, fill, r, stroke, strokeLinecap, strokeWidth, viewBox, x1, x2, y1, y2)
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
        ([ circle [ cx "200", cy "200", r "120", fill "#1293d8" ] []
         , viewHandle 6 60 (hour / 12)
         , viewHandle 6 90 (minute / 60)
         , viewHandle 1 90 (Debug.log "second" second / 60)
         ]
            -- ++ List.map viewDot (List.range 1 60)
            ++ List.map viewNumber (List.range 1 12)
        )


viewDot : Int -> Svg msg
viewDot n =
    let
        angleInTurns =
            toFloat n / 60

        x =
            String.fromFloat (200 + 120 * sin (turns angleInTurns))

        y =
            String.fromFloat (200 - 120 * cos (turns angleInTurns))

        ( width, color ) =
            if modBy 15 n == 0 then
                ( "3", "yellow" )

            else if modBy 5 n == 0 then
                ( "2", "green" )

            else
                ( "1", "red" )
    in
    circle
        [ cx x, cy y, r width, fill color ]
        []


viewNumber : Int -> Svg msg
viewNumber n =
    let
        angleInTurns =
            toFloat n / 12

        length =
            110

        x =
            String.fromFloat (200 + length * sin (turns angleInTurns) - 5)

        y =
            String.fromFloat (200 - length * cos (turns angleInTurns) + 5)
    in
    Svg.text_ [ A.x x, A.y y, fill "red" ] [ Svg.text (String.fromInt n) ]


viewHandle : Int -> Float -> Float -> Svg msg
viewHandle width length angleInTurns =
    let
        x =
            String.fromFloat (200 + length * sin (turns angleInTurns))

        y =
            String.fromFloat (200 - length * cos (turns angleInTurns))
    in
    line
        [ x1 "200"
        , y1 "200"
        , x2 x
        , y2 y
        , stroke "white"
        , strokeWidth (String.fromInt width)
        , strokeLinecap "round"
        ]
        []
