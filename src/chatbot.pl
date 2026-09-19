:- module(chatbot,
    [ chatbot_reply/3,
      chatbot_edit/4
    ]).

:- use_module(movie_maker).

chatbot_reply(Sentence, Options, response(Message, Movie, HTML)) :-
    movie(Sentence, Options, Movie),
    option(style(Style), Options, pixel),
    describe_style(Style, StyleText),
    format(string(Message), "Creating a ~w sequence with expansion, dramatization, and scene continuity.", [StyleText]),
    ( Style = vector -> movie_vector(Sentence, HTML)
    ; Style = rendered -> movie_rendered(Sentence, HTML)
    ; movie_html(Sentence, HTML)
    ).

chatbot_edit(Target, Instruction, Movie0, Movie1) :-
    regenerate(Target, Instruction, Movie0, Movie1).

describe_style(pixel, "pixelated").
describe_style(vector, "vector").
describe_style(rendered, "rendered").
