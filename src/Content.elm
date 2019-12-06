module Content exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline as DecodePipeline


type alias Content =
    { posts : List Post }


type alias Post =
    { title : String
    , url : String
    }


fetchContent : (Result Http.Error Content -> msg) -> String -> Cmd msg
fetchContent toMsg url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson toMsg decodeContent
        , timeout = Nothing
        , tracker = Nothing
        }


decodeContent : Decode.Decoder Content
decodeContent =
    Decode.succeed Content
        |> DecodePipeline.required "posts" (Decode.list decodePost)


decodePost : Decode.Decoder Post
decodePost =
    Decode.succeed Post
        |> DecodePipeline.required "title" Decode.string
        |> DecodePipeline.required "url" Decode.string


type alias Email =
    { email : String }


constructHeaders : List Http.Header -> String -> List Http.Header
constructHeaders headers token =
    headers
        ++ [ generateAuthorizationHeader token
           ]


generateAuthorizationHeader : String -> Http.Header
generateAuthorizationHeader token =
    Http.header "Authorization" <| "Bearer " ++ token


fetchExpress : (Result Http.Error Email -> msg) -> String -> String -> Cmd msg
fetchExpress toMsg token url =
    Http.request
        { method = "GET"
        , headers = constructHeaders [] token
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson toMsg decodeExpress
        , timeout = Nothing
        , tracker = Nothing
        }


decodeExpress : Decode.Decoder Email
decodeExpress =
    Decode.succeed Email |> DecodePipeline.required "email" Decode.string
