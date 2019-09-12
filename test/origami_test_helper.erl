%% ===================================================================
%% origami
%% ===================================================================
-module(origami_test_helper).

%% API
-export([set_environment_variables/0, delete_environment_variables/0]).
-export([get_config_file_path/0]).

%% macros
-define(origami_TEST_CONFIG_FILENAME, "origami-test.config").

%% ===================================================================
%% API
%% ===================================================================
set_environment_variables() ->
    % read config file
    {ok, [AppsConfig]} = file:consult(get_config_file_path()),
    % loop to set variables
    F = fun({AppName, AppConfig}) ->
        set_environment_for_app(AppName, AppConfig)
    end,
    lists:foreach(F, AppsConfig).

delete_environment_variables() ->
    EnvVars = application:get_all_env(origami),
    F = fun({Key, _Val}) ->
        application:unset_env(origami, Key)
    end,
    lists:foreach(F, EnvVars).

get_config_file_path() ->
    filename:join([support_path(), ?origami_TEST_CONFIG_FILENAME]).

%% ===================================================================
%% Internal
%% ===================================================================
support_path() ->
    filename:join([filename:dirname(code:which(?MODULE)), "support"]).

set_environment_for_app(AppName, AppConfig) ->
    F = fun({Key, Val}) ->
        application:set_env(AppName, Key, Val)
    end,
    lists:foreach(F, AppConfig).
