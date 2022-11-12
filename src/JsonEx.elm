module JsonEx exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, field, int, map4, string)



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
    | Success Quote


type alias Quote =
    { quote : String
    , source : String
    , author : String
    , year : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getRandomQuote )


getRandomQuote : Cmd Msg
getRandomQuote =
    Http.get
        { url = "https://elm-lang.org/api/random-quotes"
        , expect = Http.expectJson GotQuote quoteDecoder
        }


quoteDecoder : Decoder Quote
quoteDecoder =
    map4 Quote
        (field "quote" string)
        (field "source" string)
        (field "author" string)
        (field "year" int)



-- Update


type Msg
    = GotQuote (Result Http.Error Quote)
    | MorePlease


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        GotQuote result ->
            case result of
                Ok quote ->
                    ( Success quote, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )

        MorePlease ->
            ( Loading, getRandomQuote )



-- Subscription


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- View


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Random Quotes" ]
        , viewQuote model
        ]


viewQuote : Model -> Html Msg
viewQuote model =
    case model of
        Loading ->
            text "Loading"

        Failure ->
            div []
                [ text "I could not load a random quote for some reason. "
                , button [ onClick MorePlease ] [ text "Try Again!" ]
                ]

        Success quote ->
            div []
                [ button [ onClick MorePlease ] [ text "More Please!" ]
                , blockquote [] [ text quote.quote ]
                , p [ style "text-align" "right" ]
                    [ text "— "
                    , cite []
                        [ text quote.source ]
                    , text (" by " ++ quote.author ++ " (" ++ String.fromInt quote.year ++ ")")
                    ]
                ]
