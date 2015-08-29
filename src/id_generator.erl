-module(id_generator).
-export([next_id/1]).

next_id(Seq) ->
    receive
        {From} ->
            Time = gen_time(),
            Id = (Time bsl 10) + Seq,
            From ! {self(), Id},
            next_id(Seq + 1);
        terminate ->
            ok
    end.

gen_time() ->
    {MegaSecs, Secs, MicroSecs} = os:timestamp(),
    (MegaSecs * 1000000000) + (Secs * 1000000) + MicroSecs.
