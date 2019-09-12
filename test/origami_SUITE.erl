%% ===================================================================
%% origami
%% ===================================================================
-module(origami_SUITE).

%% callbacks
-export([all/0]).
-export([init_per_suite/1, end_per_suite/1]).
-export([groups/0, init_per_group/2, end_per_group/2]).

%% tests
-export([
    echo/1
]).

%% includes
-include_lib("common_test/include/ct.hrl").


%% ===================================================================
%% Callbacks
%% ===================================================================

%% -------------------------------------------------------------------
%% Function: all() -> GroupsAndTestCases | {skip,Reason}
%% GroupsAndTestCases = [{group,GroupName} | TestCase]
%% GroupName = atom()
%% TestCase = atom()
%% Reason = term()
%% -------------------------------------------------------------------
all() ->
    [
        {group, main}
    ].

%% -------------------------------------------------------------------
%% Function: groups() -> [Group]
%% Group = {GroupName,Properties,GroupsAndTestCases}
%% GroupName = atom()
%% Properties = [parallel | sequence | Shuffle | {RepeatType,N}]
%% GroupsAndTestCases = [Group | {group,GroupName} | TestCase]
%% TestCase = atom()
%% Shuffle = shuffle | {shuffle,{integer(),integer(),integer()}}
%% RepeatType = repeat | repeat_until_all_ok | repeat_until_all_fail |
%%			   repeat_until_any_ok | repeat_until_any_fail
%% N = integer() | forever
%% -------------------------------------------------------------------
groups() ->
    [
        {main, [shuffle], [
            echo
        ]}
    ].

%% -------------------------------------------------------------------
%% Function: init_per_suite(Config0) ->
%%				Config1 | {skip,Reason} |
%%              {skip_and_save,Reason,Config1}
%% Config0 = Config1 = [tuple()]
%% Reason = term()
%% -------------------------------------------------------------------
init_per_suite(Config) ->
    %% set default env coming from origami-test config file
    origami_test_helper:set_environment_variables(),
    %% get port
    {ok, SocketOptions} = application:get_env(origami, socket_options),
    Port = proplists:get_value(port, SocketOptions),
    %% config
    [{port, Port} | Config].

%% -------------------------------------------------------------------
%% Function: end_per_suite(Config0) -> void() | {save_config,Config1}
%% Config0 = Config1 = [tuple()]
%% -------------------------------------------------------------------
end_per_suite(_Config) ->
    %% clean
    ok.

%% -------------------------------------------------------------------
%% Function: init_per_group(GroupName, Config0) ->
%%				Config1 | {skip,Reason} |
%%              {skip_and_save,Reason,Config1}
%% GroupName = atom()
%% Config0 = Config1 = [tuple()]
%% Reason = term()
%% -------------------------------------------------------------------
init_per_group(_GroupName, Config) ->
    %% start origami
    origami:start(),
    %% wait
    timer:sleep(1000),
    %% return
    Config.

%% -------------------------------------------------------------------
%% Function: end_per_group(GroupName, Config0) ->
%%				void() | {save_config,Config1}
%% GroupName = atom()
%% Config0 = Config1 = [tuple()]
%% -------------------------------------------------------------------
end_per_group(_GroupName, _Config) ->
    %% stop
    origami:stop(),
    %% delete environment
    origami_test_helper:delete_environment_variables(),
    %% return
    ok.

%% ===================================================================
%% Tests
%% ===================================================================
echo(Config) ->
    Response = send_and_recv_response(<<"hello">>, Config),
    <<"hello">> = Response.

%% ===================================================================
%% Internal
%% ===================================================================
send_and_recv_response(Data, Config) ->
    Port = proplists:get_value(port, Config),
    SslOptions = [
        binary,
        {active, false},
        {packet, 0}
    ],
    {ok, Socket} = ssl:connect("localhost", Port, SslOptions, infinity),
    ssl:send(Socket, Data),
    {ok, Response} = ssl:recv(Socket, 0, 1000),
    ssl:close(Socket),
    Response.
