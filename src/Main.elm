port module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Content
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Url


port sendLoginLink : String -> Cmd msg


port isLogin : () -> Cmd msg


port signInWithEmail : () -> Cmd msg


port checkLogin : (Bool -> msg) -> Sub msg


port loginSuccess : (String -> msg) -> Sub msg


subscriptions : State -> Sub Msg
subscriptions _ =
    Sub.batch
        [ checkLogin CheckLogin
        , loginSuccess LoginSuccess
        ]


type State
    = Init
    | Login (Maybe String)
    | FetchContent FetchContentCarry
    | Content (List Content.Post)


type Msg
    = None
    | Email String
    | SendLink
    | CheckLogin Bool
    | LoginSuccess String
    | FetchingContentMsg (Result Http.Error Content.Content)
    | FetchingExpressMsg (Result Http.Error Content.Email)


type alias FetchContentCarry =
    { token : Maybe String }


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
                    let
                        fcarry =
                            FetchContentCarry Nothing
                    in
                    ( FetchContent fcarry, signInWithEmail () )

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

        ( FetchContent carry, LoginSuccess token ) ->
            let
                furl =
                    "http://localhost:2368/ghost/api/v3/content/posts/?key=82e1c84504fd30e47a5aad07da"

                _ =
                    Debug.log "TOKEN" token

                fcarry =
                    FetchContentCarry (Just token)
            in
            ( FetchContent fcarry, Content.fetchContent FetchingContentMsg furl )

        ( FetchContent carry, FetchingContentMsg fmsg ) ->
            case fmsg of
                Ok r ->
                    let
                        { posts } =
                            r

                        eurl =
                            "http://localhost:3000/fire"

                        _ =
                            Debug.log "token" (Just carry.token)
                    in
                    case carry.token of
                        Just t ->
                            ( Content posts, Content.fetchExpress FetchingExpressMsg t eurl )

                        Nothing ->
                            ( state, Cmd.none )

                Err _ ->
                    ( state, Cmd.none )

        ( Content p, FetchingExpressMsg fmsg ) ->
            case fmsg of
                Ok r ->
                    let
                        _ =
                            Debug.log "EXPRESS" r
                    in
                    ( state, Cmd.none )

                Err _ ->
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

            FetchContent _ ->
                div [] [ text "Loading .." ]

            Content posts ->
                let
                    _ =
                        Debug.log "** posts" posts
                in
                div []
                    (List.map
                        (\p ->
                            div [ class "m-4 p-4 rounded bg-blue-200" ]
                                [ span [ class "font-bold" ] [ text p.title ]
                                , a
                                    [ class "block hover:bg-blue-400"
                                    , href p.url
                                    , target "_blank"
                                    ]
                                    [ text p.url ]
                                ]
                        )
                        posts
                    )

            _ ->
                div [] [ text "Hello world" ]
        ]
    }
