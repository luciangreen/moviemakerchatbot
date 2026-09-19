:- module(movie_maker_app, [main/0]).

:- use_module(server).

main :-
    Port = 8080,
    start_server(Port),
    format('Movie Maker server running on http://localhost:~w~n', [Port]).
