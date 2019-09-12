%% ===================================================================
%% origami
%% ===================================================================
-module(origami_utility_test).
-include_lib("eunit/include/eunit.hrl").


%% ===================================================================
%% Tests
%% ===================================================================
raises_error_only_if_file_does_not_exist_test_() ->
    FilePath0 = "nonexistant.txt",
    ?_assertExit(
        {error, {file_does_not_exist, FilePath0}},
        origami_utility:raise_error_if_file_does_not_exist(FilePath0)
    ),

    FilePath1 = origami_test_helper:get_config_file_path(),
    ?_assertEqual(
        ok,
        origami_utility:raise_error_if_file_does_not_exist(FilePath1)
    ).
