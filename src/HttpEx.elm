module HttpEx exposing (main)

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
    | Failure
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
                Ok fulltext ->
                    ( Success fulltext, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )



-- Subscription


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- View


view : Model -> Html Msg
view model =
    case model of
        Loading ->
            text "Loading"

        Failure ->
            text "Failure"

        Success fullText ->
            pre [] [ text fullText ]
