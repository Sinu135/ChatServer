-module(chat_client).
-export([start/0, send_message/2]).

start() ->
    {ok, Socket} = gen_tcp:connect("localhost", 1234, [binary, {packet, 0}, {active, false}]),
    spawn(fun() -> receive_messages(Socket) end),
    {ok, Socket}.

send_message(Socket, Message) ->
    gen_tcp:send(Socket, Message).

receive_messages(Socket) ->
    case gen_tcp:recv(Socket, 0) of
        {ok, Message} ->
            io:format("Mensaje recibido: ~p~n", [Message]),
            receive_messages(Socket);
        {error, closed} ->
            io:format("Conexión cerrada~n"),
            ok
    end.
