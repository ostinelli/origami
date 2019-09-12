%% ===================================================================
%% origami
%% ===================================================================
-module(origami_eunit_SUITE).

%% API
-export([all/0]).

%% tests
-export([
    origami_utility_test/1
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
        origami_utility_test
    ].

%% ===================================================================
%% Tests
%% ===================================================================
origami_utility_test(_Config) ->
    ok = eunit:test(origami_utility_test).
