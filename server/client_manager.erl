-module(client_manager).
-export([start_link/0]).

start_link() ->
    register(client_manager, spawn(fun() -> client_manager([]) end)).

client_manager(Clients) ->
    receive
        {add, Socket} ->
            client_manager([Socket | Clients]);
        {remove, Socket} ->
            client_manager(lists:delete(Socket, Clients));
        {get_clients, Caller} ->
            Caller ! {clients, Clients},
            client_manager(Clients);
        _Other ->
            client_manager(Clients)
    end.
