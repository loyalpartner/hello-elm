module HttpExample exposing (..)

import Browser
import Html exposing (Html, pre, text)
import Http



-- Main


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- Model


type Model
    = Loading
    | Failure Http.Error
    | Success String


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , Http.get
        { url = ""
        , expect = Http.expectString GotText
        }
    )



-- Update


type Msg
    = GotText (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        GotText result ->
            case result of
                Ok fullText ->
                    ( Success fullText, Cmd.none )

                Err err ->
                    ( Failure err, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- View


view : Model -> Html Msg
view model =
    case model of
        Loading ->
            text "loading"

        Failure _ ->
            text "I was unable to load your book."

        Success fullText ->
            pre [] [ text fullText ]
