%% @private
-module(idgen_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% API.

start(_Type, _Args) ->
    GeneratorPid = spawn(id_generator, next_id, [1]),
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/nextid", nextid_handler, [{generator, GeneratorPid}]}
        ]}
    ]),
    {ok, _} = cowboy:start_http(http, 100, [{port, 8099}], [
        {env, [{dispatch, Dispatch}]}
    ]),
    idgen_app_sup:start_link().

stop(_State) ->
	ok.
