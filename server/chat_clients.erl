-module(chat_clients).
-export([start/0, add_client/1, remove_client/1, get_clients/0, broadcast/1]).

start() ->
    client_manager:start_link().

add_client(Socket) ->
    client_manager ! {add, Socket}.

remove_client(Socket) ->
    client_manager ! {remove, Socket}.

get_clients() ->
    client_manager ! {get_clients, self()},
    receive
        {clients, Clients} -> Clients
    end.

broadcast(Message) ->
    Clients = get_clients(),
    lists:foreach(fun(Client) -> gen_tcp:send(Client, Message) end, Clients).
