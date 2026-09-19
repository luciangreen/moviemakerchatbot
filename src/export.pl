:- module(export, [export_standalone_html/3]).

:- use_module(movie_maker).

export_standalone_html(Sentence, Mode, HTML) :-
    ( Mode = pixel -> movie_html(Sentence, HTML)
    ; Mode = vector -> movie_vector(Sentence, HTML)
    ; movie_rendered(Sentence, HTML)
    ).
