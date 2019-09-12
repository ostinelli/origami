%% ===================================================================
%% origami
%% ===================================================================
-module(origami_utility).

%% API
-export([get_env_value/1, get_env_value/2]).
-export([raise_error_if_file_does_not_exist/1]).


%% ===================================================================
%% API
%% ===================================================================
%% get an environment value
-spec get_env_value(Key :: any()) -> {ok, any()} | undefined.
get_env_value(Key) ->
    application:get_env(Key).

-spec get_env_value(Key :: any(), Default :: any()) -> {ok, any()}.
get_env_value(Key, Default) ->
    case application:get_env(Key) of
        undefined -> {ok, Default};
        {ok, Val} -> {ok, Val}
    end.

-spec raise_error_if_file_does_not_exist(FilePath :: any()) -> ok.
raise_error_if_file_does_not_exist(FilePath) ->
    case filelib:is_regular(FilePath) of
        false -> exit({error, {file_does_not_exist, FilePath}});
        _ -> ok
    end.
