-module(chat_server).
-export([start/0, accept/1, handle_message/1]).

start() ->
    {ok, ListenSocket} = gen_tcp:listen(1234, [binary, {packet, 0}, {active, false}, {reuseaddr, true}]),
    io:format("Chat server started on port 1234~n"),
    chat_clients:start(),
    accept(ListenSocket).

accept(ListenSocket) ->
    {ok, Socket} = gen_tcp:accept(ListenSocket),
    chat_clients:add_client(Socket),  % Agrega el cliente al gestor
    io:format("Client connected~n"),
    spawn(fun() -> handle_message(Socket) end),
    accept(ListenSocket).

handle_message(Socket) ->
    case gen_tcp:recv(Socket, 0) of
        {ok, Data} ->
            io:format("Received message: ~p~n", [Data]),
            chat_clients:broadcast(Data),  % Difunde el mensaje a todos los clientes
            handle_message(Socket);
        {error, closed} ->
            io:format("Client disconnected~n"),
            chat_clients:remove_client(Socket),  % Remueve el cliente al desconectarse
            ok
    end.
