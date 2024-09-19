-module(chat_client).
-export([start/0, send_message/2]).

% Manera de ingresar
start() ->
    % En gen_tcp:connect, lo primero es la dirección IP a la que se conecta, y lo segundo es el puerto
    % Para ejecutar el comando en erlang, es {ok, Socket} = chat_client:start().
    {ok, Socket} = gen_tcp:connect("25.29.49.242", 1234, [binary, {packet, 0}, {active, false}]),
    spawn(fun() -> receive_messages(Socket) end),
    {ok, Socket}.

% Envío de mensajes a la red con el formato send_message(Socket, "Insertar mensaje aquí").
send_message(Socket, Message) ->
    gen_tcp:send(Socket, Message).

% Se ejecuta una vez se detecta que se envió un mensaje.
receive_messages(Socket) ->
    case gen_tcp:recv(Socket, 0) of
        {ok, Message} ->
            io:format("Mensaje recibido: ~p~n", [Message]),
            receive_messages(Socket);
        {error, closed} ->
            io:format("Conexión cerrada~n"),
            ok
    end.