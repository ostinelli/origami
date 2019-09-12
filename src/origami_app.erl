%% ===================================================================
%% origami
%% ===================================================================
-module(origami_app).
-behaviour(application).

%% API
-export([start/2, stop/1]).


%% ===================================================================
%% API
%% ===================================================================
-spec start(
    StartType :: normal | {takeover, node()} | {failover, node()},
    StartArgs :: any()
) -> {ok, pid()} | {ok, pid(), State :: any()} | {error, any()}.
start(_StartType, _StartArgs) ->
    %% connect to nodes
    cowbell:connect_nodes(),
    %% init syn
    syn:init(),
    %% start sup
    Result = origami_sup:start_link(),
    %% start listeners
    origami_ranch:start_listeners(),
    %% return
    Result.

-spec stop(State :: any()) -> ok.
stop(_State) ->
    ok.
