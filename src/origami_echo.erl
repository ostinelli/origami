%% ===================================================================
%% origami
%% ===================================================================
-module(origami_echo).
-behaviour(ranch_protocol).

%% API
-export([start_link/4]).
-export([init/3]).

%% records
-record(state, {
    socket :: inet:socket(),
    transport :: module(),
    conn_timeout = 0 :: non_neg_integer()
}).

%% ===================================================================
%% Ranch callbacks
%% ===================================================================
-spec start_link(
    Ref :: any(),
    Socket :: inet:socket(),
    Transport :: module(),
    Opts :: map()
) -> {ok, pid()}.
start_link(Ref, _Socket, Transport, Opts) ->
    Pid = spawn_link(?MODULE, init, [Ref, Transport, Opts]),
    {ok, Pid}.

-spec init(
    Ref :: any(),
    Transport :: module(),
    Opts :: map()
) -> ok.
init(Ref, Transport, #{
    conn_timeout := ConnTimeout
}) ->
    %% socket
    {ok, Socket} = ranch:handshake(Ref),
    %% state
    State = #state{
        socket = Socket,
        transport = Transport,
        conn_timeout = ConnTimeout
    },
    echo_loop(State).

-spec echo_loop(#state{}) -> ok.
echo_loop(#state{
    socket = Socket,
    transport = Transport,
    conn_timeout = ConnTimeout
} = State) ->
    case Transport:recv(Socket, 0, ConnTimeout) of
        {ok, Data} ->
            lager:debug("received ~p, echoing back", [Data]),
            Transport:send(Socket, Data),
            echo_loop(State);
        {error, _Reason} ->
            ok = Transport:close(Socket)
    end.
