-module(id_generator).
-export([start/0]).

start() ->
    next_id(gen_time(), 0).

next_id(LastTime, LastSeq) ->
    receive
        {From} ->
            Time = gen_time(),
            Seq = case Time of
                LastTime -> LastSeq + 1;
                _ -> 1
            end,
            Id = (Time bsl 10) + Seq,
            From ! {self(), Id},
            next_id(Time, Seq);
        terminate ->
            ok
    end.

gen_time() ->
    {MegaSecs, Secs, MicroSecs} = os:timestamp(),
    (MegaSecs * 1000000000) + (Secs * 1000000) + MicroSecs.
