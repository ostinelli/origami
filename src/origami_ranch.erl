%% ===================================================================
%% origami
%% ===================================================================
-module(origami_ranch).

%% API
-export([start_listeners/0, stop_listeners/0]).

%% macros
-define(DEFAULT_NUM_ACCEPTORS, 100).
-define(DEFAULT_MAX_CONNECTIONS, 300000).

%% ===================================================================
%% API
%% ===================================================================
-spec start_listeners() -> {ok, pid()}.
start_listeners() ->
    %% get options
    {ok, NumAcceptors} = origami_utility:get_env_value(num_acceptors, ?DEFAULT_NUM_ACCEPTORS),
    {ok, MaxConnections} = origami_utility:get_env_value(max_connections, ?DEFAULT_MAX_CONNECTIONS),
    {ok, SocketOptions} = origami_utility:get_env_value(socket_options),

    %% check
    raise_if_missing_files_in_ssl_options(SocketOptions),

    %% transport options
    TransOptions = #{
        num_acceptors => NumAcceptors,
        max_connections => MaxConnections,
        socket_opts => SocketOptions
    },

    %% proto options
    ProtoOptions = #{
        conn_timeout => 5000
    },

    %% start
    Port = proplists:get_value(port, SocketOptions),
    lager:info("Starting ~p acceptors on port ~p", [NumAcceptors, Port]),
    {ok, _ListenerPid} = ranch:start_listener(
        origami_echo,
        ranch_ssl, TransOptions,
        origami_echo, ProtoOptions
    ).

-spec stop_listeners() -> ok | {error, not_found}.
stop_listeners() ->
    ranch:stop_listener(origami_client).

%% ===================================================================
%% Internal
%% ===================================================================
-spec raise_if_missing_files_in_ssl_options(list()) -> ok.
raise_if_missing_files_in_ssl_options(SslOptions) ->
    %% read ssl options
    CertFilepath = proplists:get_value(certfile, SslOptions),
    KeyFilepath = proplists:get_value(keyfile, SslOptions),
    %% raise if specified files are missing
    origami_utility:raise_error_if_file_does_not_exist(CertFilepath),
    origami_utility:raise_error_if_file_does_not_exist(KeyFilepath).
