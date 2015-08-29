%% @doc Next ID handler.
-module(nextid_handler).

-export([init/2]).

init(Req, Opts) ->
    case lists:keyfind(generator, 1, Opts) of
        {generator, Generator} ->
            Generator ! {self()},
            receive
                {Generator, Id} ->
                    io:format("id: ~w~n", [Id]),
                    Rep = cowboy_req:reply(200, [
                        {<<"content-type">>, <<"text/plain">>}
                    ], io_lib:format("~w", [Id]), Req),
                    {ok, Rep, Opts}
            end;
        false ->
            io:format("invalid option"),
            ok
    end.
