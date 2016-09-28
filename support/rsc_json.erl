-module(rsc_json).

-export([image/3, trans/2, rsc/3, rsc/4]).


trans(undefined, _) ->
    null;
trans({struct, _}=V, _) ->
    V;
trans({array, _}=V, _) ->
    V;
trans({{_,_,_}, {_,_,_}}=TS, _) ->
    z_dateformat:format(TS, "c", []);
trans(T, Context) ->
    case z_utils:is_empty(T) of
        true -> null;
        false ->
            case z_trans:trans(T, Context) of
                B when is_binary(B) ->
                    z_html:unescape(B);
                T2 -> T2
            end
    end.

image(Id, Opts, Context) ->
    case z_media_tag:url(Id, [{use_absolute_url, true} | Opts], Context) of
        {ok, Url} -> Url;
        _ -> null
    end.

rsc(Id, Fields, Context) ->
    rsc(Id, Fields, [{width, 600}], Context).

rsc(Id, Fields, ImgOpts, Context) ->
    {struct,
     [
      {id, Id},
      {category, proplists:get_value(name, m_rsc:p(Id, category, Context))}
      |
      lists:filter(fun(undefined) -> false; (_) -> true end, [map_rsc_json_field(Id, K, ImgOpts, Context)|| K <- Fields])
    ]}.

%% images
map_rsc_json_field(Id, image, ImgOpts, Context) ->
    {image, image(Id, ImgOpts, Context)};

map_rsc_json_field(Id, source_image, ImgOpts, Context) ->
    {source_image, image(Id, [{lossless, true}], Context)};

%% thumbnail
map_rsc_json_field(Id, thumbnail, ImgOpts, Context) ->
    case m_edge:objects(Id, thumbnail, Context) of
        [T | _] ->
            {thumbnail, image(T, ImgOpts, Context)};
        _ ->
            undefined
    end;

%% images
map_rsc_json_field(Id, images, ImgOpts, Context) ->
    Objects = m_edge:objects(Id, depiction, Context),
    case length(Objects) of
        N when N > 1 ->
            {images, {array, [image(ImgId, ImgOpts, Context) || ImgId <- Objects]}};
        _ ->
            undefined
    end;

%% hashtags
map_rsc_json_field(Id, hashtags, _ImgOpts, Context) ->
    Objects = m_edge:objects(Id, has_hashtag, Context),
    case length(Objects) of
        N when N > 0 ->
            {hashtags, {array, [rsc(O, [id, title], Context) || O <- Objects]}};
        _ ->
            undefined
    end;

%% dates
map_rsc_json_field(Id, DF, _, Context) when DF =:= publication_start; DF =:= publication_end;
                                            DF =:= date_start; DF =:= date_end ->
    {DF, z_datetime:format(m_rsc:p(Id, DF, Context), "c", Context)};

%% alias
map_rsc_json_field(Id, {alias, P, Alias}, ImgOpts, Context) ->
    {_, V} = map_rsc_json_field(Id, P, ImgOpts, Context),
    {Alias, V};

%% linked person; get first one
map_rsc_json_field(Id, {edge, Pred}, _ImgOpts, Context) ->
    case m_edge:objects(Id, Pred, Context) of
        [] -> {Pred, null};
        [P|_] ->
            {Pred, P}
    end;
map_rsc_json_field(Id, {edge, Pred, Fields}, ImgOpts, Context) ->
    case m_edge:objects(Id, Pred, Context) of
        [] -> {Pred, null};
        [P|_] ->
            {Pred, rsc(P, Fields, ImgOpts, Context)}
    end;
map_rsc_json_field(Id, {subject_edge, Pred, Fields}, ImgOpts, Context) ->
    case m_edge:subjects(Id, Pred, Context) of
        [] -> {Pred, null};
        [P|_] ->
            {Pred, rsc(P, Fields, ImgOpts, Context)}
    end;

map_rsc_json_field(Id, {edges, Pred, Fields}, _ImgOpts, Context) ->
    {Pred, {array, [rsc(I, Fields, _ImgOpts, Context) || I <- m_edge:objects(Id, Pred, Context)]}};

map_rsc_json_field(Id, {edges, Pred}, _ImgOpts, Context) ->
    {Pred, {array, m_edge:objects(Id, Pred, Context)}};

map_rsc_json_field(Id, {subject_edges, Pred, Fields}, _ImgOpts, Context) when is_list(Fields) ->
    {Pred, {array, [rsc(I, Fields, _ImgOpts, Context) || I <- m_edge:subjects(Id, Pred, Context)]}};

map_rsc_json_field(Id, {subject_edges, Pred}, _ImgOpts, Context) ->
    {Pred, {array, m_edge:subjects(Id, Pred, Context)}};

%% legacy
map_rsc_json_field(Id, {subject_edges, Pred, Name}, ImgOpts, Context) ->
    {Name, {array, [
                    rsc(M, [title, subtitle, image], ImgOpts, Context)
                    || M <- m_edge:subjects(Id, Pred, Context)]
           }};

map_rsc_json_field(Id, {callback, K, F}, _ImgOpts, Context) ->
    {K, F(Id, _ImgOpts, Context)};

map_rsc_json_field(Id, K, _F, Context) ->
    case trans(m_rsc:p(Id, K, Context), Context) of
        null -> undefined;
        V -> {K, V}
    end.
