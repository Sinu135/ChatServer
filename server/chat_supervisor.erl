-module(chat_supervisor).
-behaviour(supervisor).

-export([start_link/0, init/1]).
-export([start_child/1]).

%% Iniciar el supervisor
start_link() ->
    supervisor:start_link({local, chat_supervisor}, chat_supervisor, []).

%% Función de inicialización del supervisor
init([]) ->
    %% Estrategia de reinicio: un proceso se reinicia si falla
    RestartStrategy = {simple_one_for_one, 10, 60},

    %% Definir la especificación de los hijos (los procesos a supervisar)
    ChildSpec = #{id => chat_handler,
                  start => {chat_server, handle_message, []},
                  restart => permanent,
                  shutdown => brutal_kill,
                  type => worker,
                  modules => [chat_server]},

    {ok, {RestartStrategy, [ChildSpec]}}.

%% Función para iniciar un proceso hijo (el manejador de mensajes del cliente)
start_child(Socket) ->
    supervisor:start_child(chat_supervisor, [Socket]). %% Se pasa el socket al proceso hijo
