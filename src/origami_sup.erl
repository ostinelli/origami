%% ===================================================================
%% origami
%% ===================================================================
-module(origami_sup).
-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% ===================================================================
%% API
%% ===================================================================
-spec start_link() -> {ok, pid()} | {already_started, pid()} | shutdown.
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Callbacks
%% ===================================================================
-spec init([]) ->
    {ok, {{supervisor:strategy(), non_neg_integer(), pos_integer()}, [supervisor:child_spec()]}}.
init([]) ->
    Children = [],
    {ok, {{one_for_one, 10, 10}, Children}}.
