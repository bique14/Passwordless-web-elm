port module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Url


port sendLoginLink : String -> Cmd msg


port isLogin : () -> Cmd msg


port checkLogin : (Bool -> msg) -> Sub msg


subscriptions : State -> Sub Msg
subscriptions _ =
    Sub.batch
        [ checkLogin CheckLogin
        ]


type State
    = Init
    | Login (Maybe String)
    | Profile


type Msg
    = None
    | Email String
    | SendLink
    | CheckLogin Bool


type alias Model =
    { email : String }


main : Program Decode.Value State Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlRequest = \_ -> None
        , onUrlChange = \_ -> None
        }


init : Decode.Value -> Url.Url -> Nav.Key -> ( State, Cmd Msg )
init flagsValue url _ =
    ( Init, isLogin () )


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case ( state, msg ) of
        ( Init, CheckLogin b ) ->
            case b of
                True ->
                    ( Profile, Cmd.none )

                False ->
                    ( Login Nothing, Cmd.none )

        ( Login _, Email e ) ->
            ( Login (Just e), Cmd.none )

        ( Login email, SendLink ) ->
            case email of
                Just e ->
                    ( state, sendLoginLink e )

                Nothing ->
                    ( state, Cmd.none )

        _ ->
            ( state, Cmd.none )


view : State -> Browser.Document Msg
view state =
    { title = "title"
    , body =
        [ case state of
            Login email ->
                div [ class "m-2" ]
                    [ input
                        [ class "border"
                        , placeholder "email"
                        , onInput Email
                        ]
                        []
                    , button
                        [ class "border mx-2 px-2"
                        , onClick SendLink
                        ]
                        [ text "send link" ]
                    ]

            Profile ->
                div [] [ text "Login Success!" ]

            _ ->
                div [] [ text "Hello world" ]
        ]
    }
